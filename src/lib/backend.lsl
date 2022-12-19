#ifndef RV_BACKEND
#define RV_BACKEND

list __glBackendClientHeaders__ = [
  "Content-Type", "application/json"
];

string __gsBackEndUrlBase__ = "";

rvBackEndPost(string psBody) {

}

string rvMakeBackEndEndpoint(string psPath) {
  if (llGetSubString(psPath, 0, 0) != "/") {
    psPath = "/" + psPath;
  }
  return __gsBackEndUrlBase__ + psPath;
}

rvSetBackEndUrlBase(string psValue) {
  __gsBackEndUrlBase__ = psValue;
}

#endif
