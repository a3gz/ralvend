#ifndef RV_WAREHOUSE_STORAGE
#define RV_WAREHOUSE_STORAGE

#include "ralvend/src/lib/assoc-lists.lsl"

integer INFINITE_STOCK = -1;

/**
 * Strided list where:
 * i   = Inventory name
 * i+1 = Stock
 */
list __glWarehouseStorage__ = [];

list rvAddToStorage(string psProdName, integer piStock) {
  __glWarehouseStorage__ += [psProdName, piStock];
  return __glWarehouseStorage__;
}

rvCleanWarehouseStorage() {
  __glWarehouseStorage__ = [];
}

integer rvGetStock(string psProdName) {
  return rvAssocGetInteger(__glWarehouseStorage__, psProdName);
}

list rvGetStorage() {
  return __glWarehouseStorage__;
}

integer rvGetStorageSize() {
  return llGetListLength(__glWarehouseStorage__) / 2;
}

integer rvIsInfiniteStock(integer piValue) {
  return piValue == INFINITE_STOCK;
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
