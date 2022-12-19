#ifndef RV_HTTP
#define RV_HTTP

#include "ralvend/src/lib/errors.lsl"

float HTTP_SELF_URL_CHECK_TIMEOUT = 300.0; // 5 minutes

string HTTP_GET = "GET";
string HTTP_POST = "POST";
string HTTP_PUT = "PUT";
string HTTP_DELETE = "DELETE";

integer HTTP_STATUS_OK = 200;

integer HTTP_STATUS_NOT_FOUND = 404;
integer HTTP_STATUS_NOT_ACCEPTABLE = 406;
integer HTTP_STATUS_BAD_REQUEST = 409;

#endif
