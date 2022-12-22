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

integer rvUpdateStockByQty(string psProdName, integer piQty) {
  integer iQty = rvAssocGetInteger(__glWarehouseStorage__, psProdName);
  iQty += piQty;
  rvAssocSetInteger(__glWarehouseStorage__, psProdName, iQty);
  return iQty;
}

#endif
