#include "ralvend/src/lib/warehouse-storage.lsl"
#include "ralvend/src/lib/hover-text.lsl"
#include "ralvend/src/lib/logs.lsl"
#include "ralvend/src/lib/http.lsl"
#include "ralvend/src/lib/http-prim-server.lsl"
#include "ralvend/src/lib/http-back-end.lsl"
#include "ralvend/src/lib/raft/http.lsl"
#include "ralvend/src/lib/sales.lsl"
#include "ralvend/src/lib/state-texture.lsl"
#include "ralvend/src/lib/raft/raft.lsl"

string BE_ENDPOINT_SALES = "/sales";

integer CHECKLIST_URL = 0;
integer PING_TIMOUT_COUNT_BEFORE_SHUTDOWN = 3;

key gkBackEndRequest;
integer giPingTimeoutCounter = 0;
key gkOperator;
list glInitChecklist = [
  /* Is MY URL ready? */ FALSE,
  /* Am I synchronized with the back-end? */ TRUE
];

backEndRequestCallback(integer piStatus, list plMetadata, string psBody) {
  rvLogDebug("RESPONSE FROM BACKEND:");
  rvLogDebug("Status: " + (string)piStatus);
  rvLogDebug("Metadata: " + llList2CSV(plMetadata));
  rvLogDebug("Body: " + psBody);
}

generateSaleRecord(key gkCustomer, string psProdName, integer piPrice) {
  rvLogDebug("Delivered: " + psProdName + " to " + llKey2Name(gkCustomer));
  rvLogDebug("Product sold for $L" + (string)piPrice);

  string sAsJson = rvComposeSaleRecordJson(gkCustomer, psProdName, piPrice);
  rvLogDebug("POST sale record to backend:\n" + sAsJson);
  gkBackEndRequest = rvBackEndPost(
    rvBackEndComposeEndpoint(BE_ENDPOINT_SALES),
    sAsJson
  );
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

init() {
  rvCleanHoverText();
  rvRequestUrl();
  resetStorage();
  waitForReadyState(TRUE);
  rvLogSetLevel(LOGLEVEL_DEBUG);
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

resetBackEndRequest() {
  gkBackEndRequest = NULL_KEY;
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
    rvAddToStorage(sProdName, INFINITE_STOCK);
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

setOperator(key pKey) {
  gkOperator = pKey;
}

waitForReadyState(integer piRestartTimer) {
  if (!piRestartTimer) {
    llSetTimerEvent(0.0);
  } else {
    llSetTimerEvent(3.0);
  }
}

default {
  on_rez(integer start_param) {
    resetPingTimeoutCounter();
  }

  state_entry() {
    rvSetStateTexture(STATE_TEXTURE_IDLE);
    rvLogDebug("Stopped.");
    init();
  }

  changed(integer piChange) {
    if (piChange & (CHANGED_OWNER | CHANGED_REGION | CHANGED_REGION_START)) {
      init();
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
      }
    }
  }

  timer() {
    waitForReadyState(FALSE);
    if (isReady()) {
      rvLogDebug("Ready! Changing to running state...");
      state running;
    }
    rvLogDebug("Not Ready yet! Wait and check again...");
    waitForReadyState(TRUE);
  }

  touch_start(integer piNumTouches) {
    setOperator(llDetectedKey(0));
    if (isOwnerOperating()) {
      sayReport("default");
      resetPingTimeoutCounter();
    }
  }
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

state running {
  state_entry() {
    rvCleanHoverText();
    rvSetStateTexture(STATE_TEXTURE_RUNNING);
    rvLogWarning("Running...");
    llSetTimerEvent(getTimeout());
  }

  changed(integer piChange) {
    if (piChange & (CHANGED_OWNER | CHANGED_REGION | CHANGED_REGION_START)) {
      state shutdown;
    }

    if (piChange & CHANGED_INVENTORY) {
      resetStorage();
    }
  }

  http_request(key pkRequestId, string psMethod, string psBody) {
    rvRequestUrlCallback(pkRequestId, psMethod, psBody);
    if (!rvIsUrlHealthOk()) {
      rvLogError("Failed to get a secure URL:\n \n" + psBody);
      state shutdown;
    }

    if (psMethod == HTTP_POST) {
      if (psBody == "ping") {
        rvLogDebug("Pong.");
        llHTTPResponse(pkRequestId, HTTP_STATUS_OK, "pong");
      } else {
        string deliveryOrder = llJsonGetValue(psBody, ["deliveryOrder"]);
        if (deliveryOrder == JSON_NULL) {
          llHTTPResponse(pkRequestId, HTTP_STATUS_BAD_REQUEST, psBody);
        } else {
          key kCustomer = (key)llJsonGetValue(deliveryOrder, ["customer", "key"]);
          string sInventoryName = (string)llJsonGetValue(
            deliveryOrder,
            ["inventory", "name"]
          );
          integer iPrice = (integer)llJsonGetValue(
            deliveryOrder,
            ["order", "amount"]
          );

          if (!rvIsProductInStorage(sInventoryName)) {
            llHTTPResponse(pkRequestId, HTTP_STATUS_NOT_FOUND, sInventoryName);
          } else {
            integer iStock = rvGetStock(sInventoryName);
            integer infiniteStock = rvIsInfiniteStock(iStock);
            if (infiniteStock || iStock > 0) {
              llGiveInventory(kCustomer, sInventoryName);
              if (!infiniteStock) {
                rvUpdateStockByQty(sInventoryName, -1);
              }
              generateSaleRecord(kCustomer, sInventoryName, iPrice);
              llHTTPResponse(pkRequestId, HTTP_STATUS_OK, psBody);
            } else {
              llHTTPResponse(pkRequestId, HTTP_STATUS_NOT_ACCEPTABLE, psBody);
            }
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
        if (piStatus = 504) {
          rvLogError("Last ping timed out, I will pause for a while and try again...");
          state paused;
        } else {
          rvLogError("My URL is no longer responding to pings!, I must shutdown...");
          state shutdown;
        }
      }
    } else if (pkRequestId == gkBackEndRequest) {
      resetBackEndRequest();
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
      sayReport("running");
    }
  }
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

state paused {
  state_entry() {
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
///////////////////////////////////////////////////////////

state shutdown {
  state_entry() {
    rvSetStateTexture(STATE_TEXTURE_SHUTTING_DOWN);
    rvLogWarning("Shutting down...");
    llSetTimerEvent(3.0);
  }

  timer() {
    integer iCount = incrementPingTimeoutCounter();
    if (iCount <= PING_TIMOUT_COUNT_BEFORE_SHUTDOWN) {
      state running;
    } else {
      state shutdown;
    }
  }
}
