#ifndef RV_DIALOG
#define RV_DIALOG

integer __giDialogChannel__ = 0;
integer __giDialogChannelListener__;

#ifndef FUNC_RVKEY2INTEGER
#define FUNC_RVKEY2INTEGER
integer rvKey2Integer(key pKey) {
  return ((integer)("0x"+llGetSubString((string)pKey,-8,-1)) & 0x3FFFFFFF) ^ 0x3FFFFFFF;
}
#endif

integer rvDialogGetChannel() {
  return __giDialogChannel__;
}

integer rvDialogMakeChannel(key pkSeed) {
  integer iChannel = rvKey2Integer(pkSeed);
  rvDialogSetChannel(iChannel);
  return iChannel;
}

list rvOrderMenuButtons(list plButtons) {
  list lr = llList2List(plButtons, -3, -1)
    + llList2List(plButtons, -6, -4)
    + llList2List(plButtons, -9, -7)
    + llList2List(plButtons, -12, -10);
  return lr;
}

rvDialogSetChannel(integer piChannel) {
  __giDialogChannel__ = piChannel;
}

rvDialogSetListenerHandler(integer piChannel) {
  __giDialogChannelListener__ = piChannel;
}

#endif
