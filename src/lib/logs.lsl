#ifndef RV_LOGS
#define RV_LOGS

integer LOGLEVEL_DEBUG = 0;
integer LOGLEVEL_NOTICE = 1;
integer LOGLEVEL_WARNING = 2;
integer LOGLEVEL_ERROR = 3;

list __glLogPrefixes__ = ["D > ", "I > ", "W > ", "E > "];

integer __giLogLevel__ = 0;

string rvGetLogMessagePrefix(integer piLevel) {
  string r = "";
  if (piLevel >= 0 && piLevel <= 3) {
    r = llList2String(__glLogPrefixes__, piLevel);
  }
  return r;
}

rvLogDebug(string psMessage) {
  rvLog(psMessage, LOGLEVEL_DEBUG);
}

rvLogError(string psMessage) {
  rvLog(psMessage, LOGLEVEL_ERROR);
}

rvLog(string psMessage, integer piLevel) {
  if (piLevel > 0 && piLevel >= __giLogLevel__ && piLevel <= 3) {
    key kOwner = llGetOwner();
    psMessage = rvGetLogMessagePrefix(piLevel) + psMessage;
    llInstantMessage(kOwner, psMessage);
  }
}

rvLogNotice(string psMessage) {
  psMessage = psMessage;
  rvLog(psMessage, LOGLEVEL_NOTICE);
}

rvLogSetLevel(integer piLevel) {
  __giLogLevel__ = piLevel;
}

rvLogWarning(string psMessage) {
  rvLog(psMessage, LOGLEVEL_WARNING);
}

#endif
