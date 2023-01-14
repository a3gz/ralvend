#ifndef RV_LIBCONFIG
#define RV_LIBCONFIG

integer giRvCfgLineNum;
key gkRvCfgQryKey = NULL_KEY;
string gsRvCfgNcName = "config";

rvConfigDataServerCallback(key queryId, string line) {
  if (queryId == gkRvCfgQryKey) {
    if (line == EOF) {
      rvCfgUserCallback_WhenDone();
      rvConfigReset();
    } else {
      line = llStringTrim(line, STRING_TRIM);
      if (llStringLength(line) > 0) {
        rvCfgUserCallback_OnNewLine(line);
      }
      rvConfigReadNextLine();
    }
  }
}

string rvConfigGetNcName() {
  return gsRvCfgNcName;
}

rvConfigReset() {
  giRvCfgLineNum = 0;
  gkRvCfgQryKey = NULL_KEY;
}

rvConfigReadNextLine() {
  gkRvCfgQryKey = llGetNotecardLine(gsRvCfgNcName, giRvCfgLineNum++);
}

key rvConfigGetRunningQueryKey() {
  return gkRvCfgQryKey;
}

rvConfigRead() {
  if (gkRvCfgQryKey == NULL_KEY) {
    giRvCfgLineNum = 0;
    gkRvCfgQryKey = llGetNotecardLine(gsRvCfgNcName, giRvCfgLineNum++);
  }
}

rvConfigSetNcName(string psName) {
  gsRvCfgNcName = psName;
}

#endif
