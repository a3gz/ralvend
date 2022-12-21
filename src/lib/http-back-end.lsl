#ifndef RV_HTTP_BACKEND
#define RV_HTTP_BACKEND

#include "ralvend/scr/lib/raft/http.lsl"

string __gsBackEndAccessToken__ = "";
string __gsBackEndAccessExpires__ = "";
string __gsBackEndUrlBase__ = "";

string rvBackEndComposeBearerToken() {
  string sToken = "{"
    + "token:" + __gsBackEndAccessToken__,
    + "expires": + __gsBackEndAccessExpires__
    + "}";
  return llStringToBase64(sToken);
}

rvBackEndComposeCommonHeaders() {
  rrHTTPAccept(HTTP_MIMETYPE_JSON);
  rrHTTPSetHeader("Authorization", "Bearer " + rvBackEndComposeBearerToken());
}

string rvBackEndMakeEndpoint(string psPath) {
  if (llGetSubString(psPath, 0, 0) != "/") {
    psPath = "/" + psPath;
  }
  return __gsBackEndUrlBase__ + psPath;
}

rvBackEndPost(string psEndpoint, string psBody) {
  rvBackEndComposeCommonHeaders();
  return rrHTTPPost(psEndpoint, psBody);
}

rvBackEndSetAccessToken(string psValue, string psExpires) {
  __gsBackEndAccessToken__ = psValue;
  __gsBackEndAccessExpires__ = psExpires;
}

rvBackEndSetUrlBase(string psValue) {
  __gsBackEndUrlBase__ = psValue;
}

#endif
