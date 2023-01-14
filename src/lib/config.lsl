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

/**
 * General .ini file format description:
 * ; comment line
 * # comment line
 * [GroupName]
 * paramName = paramValue
 *
 * @param string line A line from the notecard
 * @param list config A list where configuration parameters are kept
 * @return list A new list with the new parameter added
 */
list rvConfigParseIniLine(string line, list config) {
  line = llStringTrim(line, STRING_TRIM);
  if (llStringLength(line) == 0
    || llGetSubString(line, 0, 0) == ";"
    || llGetSubString(line, 0, 0) == "#"
    || llGetSubString(line, 0, 0) == "["
  ) {
    return config;
  }
  list lineParts = llParseString2List(line, ["="], []);
  string name = llStringTrim(llList2String(lineParts, 0), STRING_TRIM);
  string value = llStringTrim(llList2String(lineParts, 1), STRING_TRIM);
  list newList = config + [name, value];
  return newList;
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
