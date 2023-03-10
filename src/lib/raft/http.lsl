#ifndef EXCLUDE_RR_HTTP
#ifndef RR_HTTP
  #define RR_HTTP

  /*
    http.lsl

    Contains HTTP communication helpers.
  */

  #ifndef RR_HTTP_MULTIVALIDATE
    key __RR_HTTP_LSRID;
  #else
    list __RR_HTTP_LSRIDS;
  #endif

  integer RR_HTTP_REQUEST_BODY_MAXLEN_BYT = 2048;
  integer RR_HTTP_REQUEST_BODY_MAXLEN_CHR = 1024;

  string HTTP_MIMETYPE_PLAIN_UTF8 = "text/plain;charset=utf-8";
  string HTTP_MIMETYPE_FORM_URLENCODED = "application/x-www-form-urlencoded";
  string HTTP_MIMETYPE_JSON = "application/json";
  

  // If we want to send custom headers, we use the
  // setter rrHTTPSetHeader() function to inject them
  // into this array. 
  list CUSTOM_HEADERS = [];


  rrHTTPAccept(string mimeType) {
    CUSTOM_HEADERS += [HTTP_ACCEPT, mimeType]; 
  }

  rrHTTPAppendUserAgent(string customUserAgent) {
    CUSTOM_HEADERS += [HTTP_USER_AGENT, customUserAgent]; 
  }

  key rrHTTPDelete(string url) {
    list headers = [
      HTTP_METHOD, "DELETE"
    ];
    return rrHTTPSendRequest(url, headers, "");
  }

  key rrHTTPGet(string url) {
    list headers = [HTTP_METHOD, "GET"];
    return rrHTTPSendRequest(url, headers, "");
  }

  /**
  * Convert a list into a series of URL encoded (key=value) pairs.
  *
  * data must contain an even number of elements: odd elements are field
  * names while even indexed elements are the corresponding data:
  * [
  *    "name", "SecondLifer Resident",
  *    "key", "12345678-1234-1234-1234-123456789123"
  * ]
  */
  string rrHTTPList2QueryString(list data) {
    string queryString = "";
    
    integer ptr;
    integer count = (integer)llGetListLength(data);
    
    for (ptr = 0; ptr < count; ptr += 2) {
      queryString = queryString
        + llEscapeURL(llList2String(data, ptr))
        + "="
        + llEscapeURL(llList2String(data, ptr+1));
      if (ptr+2 < count) {
        queryString = queryString + "&";
      }
    }
    return queryString;
  }

  key rrHTTPPost(string url, string data) {
    list headers = [
      HTTP_METHOD, "POST"
    ];
    return rrHTTPSendRequest(url, headers, data);
  }

  key rrHTTPPut(string url, string data) {
    list headers = [
      HTTP_METHOD, "PUT"
    ];
    return rrHTTPSendRequest(url, headers, data);
  }

  key rrHTTPRequest(string url, list data, string body){
    if (rrStringContains(url, "agni.lindenlab.com:12046")
      && llStringLength(body) > RR_HTTP_REQUEST_BODY_MAXLEN_BYT
    ) {
      rvLogError(
        "HTTP request being transmitted to in-world URL exceeds maximum recipient body "
        +"length of "+(string)RR_HTTP_REQUEST_BODY_MAXLEN_BYT+" bytes ("+
        (string)RR_HTTP_REQUEST_BODY_MAXLEN_CHR+" characters /w Mono). Request cancelled."
      );

      return NULL_KEY;
    }

    #ifndef RR_HTTP_MULTIVALIDATE
      __RR_HTTP_LSRID = llHTTPRequest(url, data, body);
      return __RR_HTTP_LSRID;
    #else
      key srid = llHTTPRequest(url, data, body);
      __RR_HTTP_LSRIDS += srid;
      return srid;
    #endif
  }

  key rrHTTPSendRequest(string url, list params, string body) {
    params += CUSTOM_HEADERS;
    CUSTOM_HEADERS = [];
    rvLogTrace("\n\n" + url + "\n"
      + llDumpList2String(params, " # ") + "\n"
      + body + "\n"
    );

    return rrHTTPRequest(url, params, body);
  }

  /**
   * Mono Max: 16384
   * LSO Max: 4096
   */
  rrHTTPSetBodyMaxLength(integer maxLen) {
    CUSTOM_HEADERS += [HTTP_BODY_MAXLENGTH, maxLen];
  }

  rrHTTPSetExtendedError(integer extended) {
    CUSTOM_HEADERS += [HTTP_EXTENDED_ERROR, extended];
  }

  // Add a custom header
  rrHTTPSetHeader(string name, string value) {
    CUSTOM_HEADERS += [HTTP_CUSTOM_HEADER, name, value];
  }

  rrHTTPSetMimeType(string mimeType) {
    CUSTOM_HEADERS += [HTTP_MIMETYPE, mimeType];
  }

  rrHTTPSetPragmaNoCache(integer sendHeader) {
    CUSTOM_HEADERS += [HTTP_PRAGMA_NO_CACHE, sendHeader];
  }

  rrHTTPSetVerboseThrottle(integer noisy) {
    CUSTOM_HEADERS += [HTTP_VERBOSE_THROTTLE, noisy];
  }

  rrHTTPSetVerifyCert(integer verify) {
    CUSTOM_HEADERS += [HTTP_VERIFY_CERT, verify];
  }

  integer rrHTTPValidateResponse(key reqid){
    #ifndef RR_HTTP_MULTIVALIDATE
      return (reqid == __RR_HTTP_LSRID);
    #else
      integer index = llListFindList(__RR_HTTP_LSRIDS, [reqid]);
      if(index==-1)
        return false;
      __RR_HTTP_LSRIDS = llDeleteSubList(__RR_HTTP_LSRIDS, index, index);
      return TRUE;
    #endif
  }
#endif
#endif
