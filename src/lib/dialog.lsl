#ifndef RV_DIALOG
  #define RV_DIALOG

  #ifndef FUNC_RVKEY2INTEGER
  #define FUNC_RVKEY2INTEGER
  integer rvKey2Integer(key pKey) {
    return ((integer)("0x"+llGetSubString((string)pKey,-8,-1)) & 0x3FFFFFFF) ^ 0x3FFFFFFF;
  }
  #endif
  
  list rvOrderMenuButtons(list plButtons) {
    list lr = llList2List(plButtons, -3, -1)
      + llList2List(plButtons, -6, -4)
      + llList2List(plButtons, -9, -7)
      + llList2List(plButtons, -12, -10);
    return lr;
  }

#endif
