#ifndef RV_TIME
#define RV_TIME

/**
 * Anti-License Text
 * Contributed Freely to the Public Domain without limitation.
 * 2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]
 * Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]
 * Source: https://wiki.secondlife.com/wiki/Stamp2UnixInt
 */
integer rvStamp2UnixInt(list vLstStp) {
  integer vIntYear = llList2Integer( vLstStp, 0 ) - 1902;
  integer vIntRtn;
  if (vIntYear >> 31 | vIntYear / 136) {
    vIntRtn = 2145916800 * (1 | vIntYear >> 31);
  } else {
    integer vIntMnth = ~-llList2Integer( vLstStp, 1 );
    integer vIntDays = ~-llList2Integer( vLstStp, 2 );
    vIntMnth = llAbs( (vIntMnth + !~vIntMnth) % 12 );
    vIntRtn = 86400 * ((integer)(vIntYear * 365.25 + 0.25) - 24837 +
      vIntMnth * 30 + (vIntMnth - (vIntMnth < 7) >> 1) + (vIntMnth < 2) -
      (((vIntYear + 2) & 3) > 0) * (vIntMnth > 1) +
      llAbs( (vIntDays + !~vIntDays) % 31 ) ) +
      llAbs( llList2Integer( vLstStp, 3 ) % 24 ) * 3600 +
      llAbs( llList2Integer( vLstStp, 4 ) % 60 ) * 60 +
      llAbs( llList2Integer( vLstStp, 5 ) % 60 );
  }
  return vIntRtn;
}

integer rvUnixTimestamp() {
  list lTimestamp = llParseString2List(llGetTimestamp(), ["-",":"], ["T"]);
  return rvStamp2UnixInt(lTimestamp);
}

#endif
