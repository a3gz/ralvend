#include "ralvend/src/lib/warehouse-storage.lsl"
#include "ralvend/src/lib/hover-text.lsl"
#include "ralvend/src/lib/errors.lsl"
#include "ralvend/src/lib/http.lsl"
#include "ralvend/src/lib/http-server-prim.lsl"
#include "ralvend/src/lib/raft/http.lsl"
#include "ralvend/src/lib/state-texture.lsl"

integer CHECKLIST_URL = 0;

key gkOperator;
list glInitChecklist = [
  /* Is MY URL ready? */ FALSE,
  /* Am I synchronized with the back-end? */ TRUE /* mockup value*/
];

generateSaleRecord(key gkCustomer, string psProdName, integer piPrice) {
  rvLog("Delivered: " + psProdName + " to " + llKey2Name(gkCustomer));
  rvLog("Product sold for $L" + (string)piPrice);
    // Perform administrative tasks to record sales, 
    // notify involved perties, etc.
    // Recording the sale must include linking the customer to the product
    // in case they request a redelivery down the road.
}

float getTimeout() {
  // For the moment we are only using the timet to ping the URL.
  // The ping has its own time check so we can set the timere to whatever
  // the warehouse needs.
  return HTTP_SELF_URL_CHECK_TIMEOUT;
}

init() {
  rvCleanHoverText();
  rvRequestUrl();
  resetStorage();
  waitForReadyState(TRUE);
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
    rvLog(sReport);
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
  state_entry() {
    rvSetStateTexture(STATE_TEXTURE_IDLE);
    rvLog("Stopped.");
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
        setInitChecklist(CHECKLIST_URL, TRUE);
      }
    }
  }

  timer() {
    waitForReadyState(FALSE);
    if (isReady()) {
      rvLog("Ready! Changing to running state...");
      state running;
    }
    rvLog("Not Ready yet! Wait and check again...");
    waitForReadyState(TRUE);
  }

  touch_start(integer piNumTouches) {
    setOperator(llDetectedKey(0));
    if (isOwnerOperating()) {
      sayReport("default");
    }
  }
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

state running {
  state_entry() {
    rvCleanHoverText();
    rvSetStateTexture(STATE_TEXTURE_RUNNING);
    rvLog("Running...");
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
      state shutdown;
    }

    if (psMethod == HTTP_POST) {
      if (psBody == "ping") {
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
        rvThrow("My URL is no longer responding to pings!, I must shutdown...");
        state shutdown;
      }
    }

    if (pkRequestId == NULL_KEY) {
      rvThrow("Too many HTTP responses!");
    }
  }

  timer() {
    if (rvIsTimeToPingUrl()) {
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

state shutdown {
  state_entry() {
    rvSetStateTexture(STATE_TEXTURE_SHUTTING_DOWN);
    rvLog("Shutting down...");
    llSetTimerEvent(3.0);
  }

  timer() {
    state default;
  }
}
