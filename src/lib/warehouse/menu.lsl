#ifndef RV_WAREHOUSE_MENU
#define RV_WAREHOUSE_MENU

#include "ralvend/src/lib/dialog.lsl"

rvOpenWarehouseMenu(string psState, key pkOperator, string psMessage) {
  integer iChannel = rvDialogMakeChannel(llGetKey());
  string sMenuMessage = psMessage;
  list lOptions = [];

  llListenRemove(iChannel);
  rvDialogSetListenerHandler(llListen(iChannel, "", gkOperator, ""));
  llDialog(pkOperator, sMenuMessage, lOptions, iChannel);
  llSetTimerEvent(15.0);
}

#endif
