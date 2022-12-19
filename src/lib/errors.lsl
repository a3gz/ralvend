#ifndef RV_ERRORS
#define RV_ERRORS

rvLog(string psMessage) {
  key kOwner = llGetOwner();
  llInstantMessage(kOwner, psMessage);
}

rvThrow(string psMessage) {
  key kOwner = llGetOwner();
  llInstantMessage(kOwner, "E! " + psMessage);
}

#endif
