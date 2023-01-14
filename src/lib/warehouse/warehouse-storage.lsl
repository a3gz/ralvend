#ifndef RV_WAREHOUSE_STORAGE
#define RV_WAREHOUSE_STORAGE

#include "ralvend/src/lib/assoc-lists.lsl"

list __glWarehouseStorage__ = [];

list rvAddToStorage(string psProdName) {
  __glWarehouseStorage__ += [psProdName];
  return __glWarehouseStorage__;
}

rvCleanWarehouseStorage() {
  __glWarehouseStorage__ = [];
}

list rvGetStorage() {
  return __glWarehouseStorage__;
}

string rvGetStorageAsJsonArray() {
  list lQuotedList = [];
  integer i;
  for (i = 0; i < rvGetStorageSize(); i++) {
    lQuotedList += ["\"" + llList2String(__glWarehouseStorage__, i)  +"\""];
  }
  return llList2Json(JSON_ARRAY, lQuotedList);
}

integer rvGetStorageSize() {
  return llGetListLength(__glWarehouseStorage__);
}

integer rvIsProductInStorage(string psProdName) {
  integer i = llListFindList(__glWarehouseStorage__, [psProdName]);
  if (i < 0) {
    return FALSE;
  }
  return TRUE;
}

#endif
