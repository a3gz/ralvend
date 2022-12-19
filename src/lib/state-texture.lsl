#ifndef RV_STATE_TEXTURE
#define RV_STATE_TEXTURE

integer STATE_TEXTURE_IDLE = 0;
integer STATE_TEXTURE_RUNNING = 1;
integer STATE_TEXTURE_SHUTTING_DOWN = 2;

integer __giStateTextureFace__ = 1;

rvSetStateTextureFace(integer piFace) {
  __giStateTextureFace__ = piFace;
}

rvSetStateTexture(integer piState) {
  string sTexture = "state_idle";
  if (piState == STATE_TEXTURE_RUNNING) {
    sTexture = "state_running";
  } else if (piState == STATE_TEXTURE_SHUTTING_DOWN) {
    sTexture = "state_shutting_down";
  }

  integer iCount = llGetInventoryNumber(INVENTORY_TEXTURE);
  integer iDone = FALSE;
  integer i = 0;
  do {
    string sTextureName = llGetInventoryName(INVENTORY_TEXTURE, i);
    if (sTextureName == sTexture) {
      llSetTexture(sTexture, __giStateTextureFace__);
      iDone = TRUE;
    }
    i++;
  } while (i < iCount && !iDone);
}

#endif
