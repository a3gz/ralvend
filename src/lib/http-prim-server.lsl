#ifndef RV_HTTP_SERVER_PRIM
#define RV_HTTP_SERVER_PRIM

#include "ralvend/src/lib/time.lsl"

/**
 * RalVend components communicate with each other and with the back-end via 
 * HTTP requests.
 * Some components such as the Warehouse are capable of processing HTTP
 * requests. To do this they need a public URL.
 * This library file provides a wrapping environment facilitate the process
 * of obtaining and maintaining a URL.
 *
 * Please, never use any variable that begins and ends with __. Instead, use the
 * provided getters/setters functions.
 */

float HTTP_SELF_URL_CHECK_TIMEOUT = 60.0;

// Configuration variables
integer __giUseSecureUrl__ = FALSE;

// Runtime variables
key __gkUrlRequestKey__;
key __gkPingRequestKey__;
integer __giTimeAtLastPing__ = 0;
integer __giLastPongTimestamp__ = 0;
integer __giUrlHealthOk__;
string __gsSecureUrl__ = "";


integer getLastPongTimestamp() {
  return __giLastPongTimestamp__;
}

string rvGetLastUrl() {
  return __gsSecureUrl__;
}

key rvGetPingRequestId() {
  return __gkPingRequestKey__;
}

key rvGetUrlRequestId() {
  return __gkUrlRequestKey__;
}

integer rvIsTimeToPingUrl() {
  float fNextPingAt = __giTimeAtLastPing__ + HTTP_SELF_URL_CHECK_TIMEOUT;
  float fTime = rvUnixTimestamp();
  return fTime >= fNextPingAt;
}

integer rvIsUrlHealthOk() {
  return rvGetLastUrl() != "";
}

rvMarkLastPongTimestamp() {
  __giLastPongTimestamp__ = rvUnixTimestamp();
}

integer rvPingCallback(integer piStatus) {
  __gkPingRequestKey__ = NULL_KEY;
  return (piStatus == HTTP_STATUS_OK);
}

rvPingUrl() {
  __gkPingRequestKey__ = llHTTPRequest(
    __gsSecureUrl__,
    [
      HTTP_METHOD, "POST",
      HTTP_VERBOSE_THROTTLE, FALSE,
      HTTP_BODY_MAXLENGTH, 16384
    ],
    "ping"
  );
  __giTimeAtLastPing__ = rvUnixTimestamp();
}

rvRequestUrl() {
  rvReleaseUrl();
  if (__giUseSecureUrl__) {
    __gkUrlRequestKey__ = llRequestSecureURL();
  } else {
    __gkUrlRequestKey__ = llRequestURL();
  }
}

rvRequestUrlCallback(key pkRequestId, string psMethod, string psBody) {
  if (psMethod == URL_REQUEST_DENIED) {
    __gsSecureUrl__ = "";
    __giUrlHealthOk__ = FALSE;
  } else if (psMethod == URL_REQUEST_GRANTED) {
    __gsSecureUrl__ = psBody;
  }
  __giUrlHealthOk__ = TRUE;
}

rvReleaseUrl() {
  llReleaseURL(__gsSecureUrl__);
  __gsSecureUrl__ = "";
}

rvSetUseSecureUrl(integer pi) {
  __giUseSecureUrl__ = pi;
}

#endif
