#ifndef RV_SALES
#define RV_SALES

string rvComposeSaleRecordJson(key pkCustomer, string psProdName, integer piPrice) {
  string s = "{"
    + "customer" : "{"
      + "key:" + (string)pkCustomer + ""
    + "},"
    + "inventory" : "{"
      + "name:" + (string)psProdName + ""
    + "},"
    + "order" : "{"
      + "amount:" + (string)piPrice + ""
    + "}";
  return s;
}

#endif
