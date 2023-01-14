#include "ralvend/src/lib/warehouse/warehouse-storage.lsl"
#include "ralvend/src/lib/hover-text.lsl"
#include "ralvend/src/lib/logs.lsl"
#include "ralvend/src/lib/dialog.lsl"
#include "ralvend/src/lib/http.lsl"
#include "ralvend/src/lib/http-prim-server.lsl"
#include "ralvend/src/lib/http-back-end.lsl"
#include "ralvend/src/lib/raft/http.lsl"
#include "ralvend/src/lib/state.lsl"
#include "ralvend/src/lib/time.lsl"
#include "ralvend/src/lib/raft/raft.lsl"

integer CHECKLIST_URL = 0;
integer CHECKLIST_SYNC = 1;
integer PING_TIMOUT_COUNT_BEFORE_SHUTDOWN = 3;

integer giDialogChannel = 0;

key gkBackEndSyncRequest;
integer giPingTimeoutCounter = 0;
key gkOperator;
list glInitChecklist = [
  /* My URL is ready */ FALSE,
  /* I'm synchronized with the back-end */ TRUE
];

backEndRequestCallback(integer piStatus, list plMetadata, string psBody) {
  rvLogDebug("RESPONSE FROM BACKEND:");
  rvLogDebug("Status: " + (string)piStatus);
  rvLogDebug("Metadata: " + llList2CSV(plMetadata));
  rvLogDebug("Body: " + psBody);
}

list buildStatusData() {
  return llList2Json(JSON_OBJECT, [
    "url", rvGetLastUrl(),
    "inventory", rvGetStorageAsJsonArray(),
    "lastPongTimestamp", getLastPongTimestamp()
  ]);
}

float getTimeout() {
  // For the moment we are only using the timet to ping the URL.
  // The ping has its own time check so we can set the timere to whatever
  // the warehouse needs.
  return HTTP_SELF_URL_CHECK_TIMEOUT;
}

integer incrementPingTimeoutCounter() {
  giPingTimeoutCounter += 1;
  return giPingTimeoutCounter;
}

integer isOwnerOperating() {
  return gkOperator == llGetOwner();
}

integer isReady() {
  integer iReady = TRUE;
  integer iCount = llGetListLength(glInitChecklist);
  integer i;
  for (i = 0; i < iCount; i++) {
    iReady = iReady && llList2Integer(glInitChecklist, i);
  }
  return iReady;
}

openMenu(string psState) {
  if (psState == "default") {
    sayReport("default");
  } else if (psState == "running") {
    sayReport("running");
  }
}

resetBackEndSyncRequest() {
  gkBackEndSyncRequest = NULL_KEY;
}

resetPingTimeoutCounter() {
  giPingTimeoutCounter = 0;
}

resetStorage() {
  rvCleanWarehouseStorage();

  integer i;
  integer iCount = llGetInventoryNumber(INVENTORY_OBJECT);
  for (i = 0; i < iCount; i++) {
    string sProdName = llGetInventoryName(INVENTORY_OBJECT, i);
    rvAddToStorage(sProdName);
  }
}

sayReport(string psState) {
  string sReport = "";
  if (psState == "default") {
    sReport += "State: Stopped.\n";
    sReport += "URL: " + rvGetLastUrl() + "\n";
  } else if (psState == "running") {
    sReport += "State: Running.\n";
    sReport += "URL: " + rvGetLastUrl() + "\n";
  }
  if (sReport != "") {
    rvLogTrace(sReport);
  }
}

setInitChecklist(integer piIndex, integer piValue) {
  glInitChecklist = llListReplaceList(
    glInitChecklist,
    [piValue],
    piIndex,
    piIndex
  );
}

setObjectStateProperties(integer piState) {
  rvApplyStateTexture(piState);
}

setOperator(key pKey) {
  gkOperator = pKey;
}

start() {
  rvCleanHoverText();
  resetPingTimeoutCounter();
  rvRequestUrl();
  resetStorage();
  waitForReadyCondition(TRUE);
}

syncWithBackEnd() {
  // gkBackEndSyncRequest = rvSyncWithBackEnd(buildStatusData());
}

/**
 * Starts a timer to wait until initialization tasks are complete and the
 * object has everything it needs to run.
 * The global variable `glInitChecklist` defines all the things that need to
 * occur for the script to go to the `running` state.
 */
waitForReadyCondition(integer piRestartTimer) {
  if (!piRestartTimer) {
    llSetTimerEvent(0.0);
  } else {
    llSetTimerEvent(3.0);
  }
}

///////////////////////////////////////////////////////////
// STATE: default
///////////////////////////////////////////////////////////

default {
  on_rez(integer start_param) {
    rvSetUseSecureUrl(TRUE);
    llResetScript();
  }

  state_entry() {
    rvLogDebug("Stopped.");
    rvLogSetLevel(LOGLEVEL_DEBUG);
    setObjectStateProperties(STATE_IDLE);
    // The warehouse needs to always be running.
    // Every time the object falls into the default status, whether it's
    // because it was just rezzed or it went offline for external reasons
    // it tries to get back up.
    start();
  }

  changed(integer piChange) {
    if (piChange & (CHANGED_OWNER | CHANGED_REGION | CHANGED_REGION_START)) {
      llResetScript();
    }

    if (piChange & CHANGED_INVENTORY) {
      resetStorage();
    }
  }

  http_request(key pkRequestId, string psMethod, string psBody) {
    if (pkRequestId == rvGetUrlRequestId()) {
      rvRequestUrlCallback(pkRequestId, psMethod, psBody);
      if (!rvIsUrlHealthOk()) {
        rvRequestUrl();
      } else {
        rvLogDebug("My URL is " + rvGetLastUrl());
        setInitChecklist(CHECKLIST_URL, TRUE);
        syncWithBackEnd();
      }
    } else {
      llOwnerSay("Unknown incoming request...");
    }
  }

  timer() {
    waitForReadyCondition(FALSE);
    if (isReady()) {
      rvLogDebug("Ready! Changing to running state...");
      state running;
    }
    rvLogDebug("Not Ready yet! Wait and check again...");
    waitForReadyCondition(TRUE);
  }

  touch_start(integer piNumTouches) {
    if (giDialogChannel == 0) {
      giDialogChannel = rvKey2Integer(llGetKey()) * -1;
    }
    setOperator(llDetectedKey(0));
    if (isOwnerOperating()) {
      openMenu("default");
    }
  }
}

///////////////////////////////////////////////////////////
// STATE: running
///////////////////////////////////////////////////////////

state running {
  state_entry() {
    rvCleanHoverText();
    setObjectStateProperties(STATE_RUNNING);
    rvLogWarning("Running...");
    llSetTimerEvent(getTimeout());
  }

  changed(integer piChange) {
    if (piChange & (CHANGED_OWNER | CHANGED_REGION | CHANGED_REGION_START)) {
      state shutting_down;
    }

    if (piChange & CHANGED_INVENTORY) {
      resetStorage();
    }
  }

  http_request(key pkRequestId, string psMethod, string psBody) {
    rvRequestUrlCallback(pkRequestId, psMethod, psBody);
    if (!rvIsUrlHealthOk()) {
      rvLogError("Failed to get a secure URL:\n \n" + psBody);
      state shutting_down;
    }

    if (psMethod == HTTP_POST) {
      if (psBody == "ping") {
        rvLogDebug("Pong.");
        rvMarkLastPongTimestamp();
        llHTTPResponse(pkRequestId, HTTP_STATUS_OK, "pong");
      } else {
        string deliveryOrder = llJsonGetValue(psBody, ["deliveryOrder"]);
        if (deliveryOrder == JSON_NULL) {
          llHTTPResponse(pkRequestId, HTTP_STATUS_BAD_REQUEST, psBody);
        } else {
          key kCustomer = (key)llJsonGetValue(deliveryOrder, ["customerKey"]);
          string sInventoryName = (string)llJsonGetValue(
            deliveryOrder,
            ["inventoryName"]
          );

          if (!rvIsProductInStorage(sInventoryName)) {
            llHTTPResponse(pkRequestId, HTTP_STATUS_NOT_FOUND, sInventoryName);
          } else {
            llGiveInventory(kCustomer, sInventoryName);
            llHTTPResponse(pkRequestId, HTTP_STATUS_OK, psBody);
          }
        }
      }
    }
  }

  http_response(key pkRequestId, integer piStatus, list plMetadata, string psBody) {
    if (pkRequestId == rvGetPingRequestId()) {
      integer iPingOk = rvPingCallback(piStatus);
      if (!iPingOk) {
        rvLogError("Ping response status: " + (string)piStatus);
        if (piStatus = HTTP_GATEWAY_TIMEOUT) {
          integer iCount = incrementPingTimeoutCounter();
          if (iCount <= PING_TIMOUT_COUNT_BEFORE_SHUTDOWN) {
            rvLogError(
              "Last ping timed out, I will pause for a while and try again..."
            );
            state paused;
          } else {
            state shutting_down;
          }
        } else {
          rvLogError(
            "My URL is no longer responding to pings!, I must shutting_down..."
          );
          state shutting_down;
        }
      }
    } else if (pkRequestId == gkBackEndSyncRequest) {
      resetBackEndSyncRequest();
      backEndRequestCallback(piStatus, plMetadata, psBody);
    }

    if (pkRequestId == NULL_KEY) {
      rvLogError("Too many HTTP responses!");
    }
  }

  timer() {
    if (rvIsTimeToPingUrl()) {
      rvLogDebug("Ping...");
      rvPingUrl();
    }
  }

  touch_start(integer piNumTouches) {
    setOperator(llDetectedKey(0));
    if (isOwnerOperating()) {
      openMenu("running");
    }
  }
}

///////////////////////////////////////////////////////////
// STATE: paused
///////////////////////////////////////////////////////////

state paused {
  state_entry() {
    setObjectStateProperties(STATE_PAUSED);
    float fTimeout = 5.0;
    string sTimeout = (string)((integer)(fTimeout * 100) / 100);
    rvLogDebug("Pausing for " + (string)sTimeout + " seconds...");
    llSetTimerEvent(fTimeout);
  }

  timer() {
    state running;
  }
}

///////////////////////////////////////////////////////////
// STATE: shutting_down
///////////////////////////////////////////////////////////

state shutting_down {
  state_entry() {
    setObjectStateProperties(STATE_SHUTTING_DOWN);
    rvLogWarning("Shutting down...");
    llSetTimerEvent(5.0);
  }

  timer() {
    llResetScript();
  }
}
