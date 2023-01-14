#include "ralvend/src/lib/warehouse/warehouse-storage.lsl"
#include "ralvend/src/lib/config.lsl"
#include "ralvend/src/lib/hover-text.lsl"

/**
 * Batch Redelivery
 *
 * - Create an object and throw the following in its content:
 *   - This script
 *   - A noetcard having a list of agent names and inventory items to deliver
 *     (one inventory item per agent)
 *   - The objects to deliver
 *
 * Notecard format
 * Agent Name, Agent Key, Inventory Name
 */

key gkOperator;

list glProcessed = [];
integer giLastDeliveredEntry = -1;
string gsDatabaseName = "database.csv";

list glDatabase = [];
integer STRIDE_SIZE = 3;
integer STRIDE_AGENT_NAME = 0;
integer STRIDE_AGENT_KEY = 1;
integer STRIDE_INVENTORY_NAME = 2;
// https://wiki.secondlife.com/wiki/LlGiveInventory
integer MAX_BATCH_SIZE = 2000;

integer calculateNumEntries() {
  return llGetListLength(glDatabase) / 3;
}

integer deliver() {
  rvSetHoverText("Delivering...");
  llSleep(1.0);
  integer iCount = calculateNumEntries();
  integer iBatchCount = 0;
  integer i = giLastDeliveredEntry;
  for (; i < iCount; i++) {
    integer iOffset = i * STRIDE_SIZE;
    string sAgentName = llList2String(glDatabase, iOffset+STRIDE_AGENT_NAME);
    key kAgentKey = llList2String(glDatabase, iOffset+STRIDE_AGENT_KEY);
    string sInventoryName = llList2String(
      glDatabase,
      iOffset+STRIDE_INVENTORY_NAME
    );
    rvLogTrace(sAgentName + " <= " + sInventoryName);
    llGiveInventory(kAgentKey, sInventoryName);
    giLastDeliveredEntry = i;
    iBatchCount += 1;
    if (iBatchCount > MAX_BATCH_SIZE) {
      return FALSE;
    }
  }
  return TRUE;
}

integer isOwnerOperating() {
  return gkOperator == llGetOwner();
}

resetLastDeliveredEntry() {
  giLastDeliveredEntry = 0;
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

rvCfgUserCallback_OnNewLine(string psLine) {
  if (llGetSubString(psLine, 0, 0) != "#") {
    list lLineParts = llCSV2List(psLine);
    string sAgentName = llList2String(lLineParts, STRIDE_AGENT_NAME);
    key kAgentKey = llList2Key(lLineParts, STRIDE_AGENT_KEY);
    string sInventoryName = llList2String(lLineParts, STRIDE_INVENTORY_NAME);
    glDatabase += [sAgentName, kAgentKey, sInventoryName];
  }
}

rvCfgUserCallback_WhenDone() {
  resetStorage();
}

setOperator(key pKey) {
  gkOperator = pKey;
}

default {
  state_entry() {
    resetLastDeliveredEntry();
    rvCleanHoverText();
    rvSetHoverText(
      "Drop the assets then touch to start..."
    );
  }

  changed(integer piChange) {
    if (piChange & (CHANGED_OWNER | CHANGED_REGION | CHANGED_REGION_START)) {
      llResetScript();
    }

    if (piChange & CHANGED_INVENTORY) {
      rvSetHoverText("New inventory detected");
    }
  }

  touch_start(integer piCount) {
    setOperator(llDetectedKey(0));
    if (isOwnerOperating()) {
      state readingConfig;
    }
  }
}

/**
 * STATE: readingConfig
 */
state readingConfig {
  state_entry() {
    rvSetHoverText("Reading configuration...");
    rvConfigSetNcName(gsDatabaseName);
    rvConfigRead();
  }

  dataserver(key queryId, string line) {
    if (line == EOF) {
      rvConfigDataServerCallback(queryId, line);
      state delivering;
    } else {
      rvConfigDataServerCallback(queryId, line);
    }
  }
}

/**
 * STATE: done
 */
state done {
  state_entry() {
    rvSetHoverText("Done! Please wait...");
    llSetTimerEvent(5);
  }

  timer() {
    state default;
  }
}

/**
 * STATE: delivering
 */
state delivering {
  state_entry() {
    if (!deliver()) {
      state waitBecauseThrottle;
    } else {
      state done;
    }
  }
}

/**
 * SATTE: waitBecauseThrottle
 */
state waitBecauseThrottle {
  state_entry() {
    rvSetHoverText("Throttle time = 32 seconds...");
    llSetTimerEvent(32.0);
  }

  timer() {
    state delivering;
  }
}
