#ifndef RV_ASSOC_LISTS
#define RV_ASSOC_LISTS

integer rvAssocGetInteger(list plAssoc, string psKey){
  integer index = llListFindList(plAssoc, [psKey]);
  if (index == -1) {
    return 0;
  }
  return llList2Integer(plAssoc, index+1);
}

string rvAssocGetString(list assoc, string sKey){
  integer index = llListFindList(assoc, [sKey]);
  if (index == -1) {
    return "";
  }
  return llList2String(assoc, index+1);
}

list rvAssocSetInteger(list plAssoc, string psKey, integer piNewValue) {
  integer index = llListFindList(plAssoc, [psKey]);
  if (index == -1) {
    return plAssoc;
  }
  return llListReplaceList(plAssoc, [piNewValue], index+1, index+1);
}

list rvCSV2List(string psCsv) {
  list lTemp = llCSV2List(psCsv);
  list lFinal = [];
  integer i;
  for (i=0; i < len; i++) {
    lFinal += [llStringTrim(llList2String(lTemp, i), STRING_TRIM)];
  }
  return lFinal;
}


#endif
