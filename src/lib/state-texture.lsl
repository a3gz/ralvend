#ifndef RV_STATE_TEXTURE
#define RV_STATE_TEXTURE

/**
 * This library is an alternative to hover texts to show the status of a
 * component by stamping a texture on the object instead.
 * By default we assume that the status can be: idle, running, shutting down
 * and paused; but this can be easily changed using the provided API functions.
 *
 * Also by default this library assumes that we want to use textures located
 * inside the object's inventory and that we are going to apply them by name.
 * This also can be easily changed by setting a different list of values
 * rvSetSetStateTexturesList() with UUIDs instead.
 *
 * Finally we can toggle whether we want the texture to be applied without
 * checking the inventory: rvSetStateTextureInventoryCheck(FALSE);
 */

integer STATE_TEXTURE_IDLE = 0;
integer STATE_TEXTURE_RUNNING = 1;
integer STATE_TEXTURE_SHUTTING_DOWN = 2;
integer STATE_TEXTURE_PAUSED = 3;
integer MAX_TEXTURE_INDEX = 3;

integer __giStateTextureCheckInventory__ = 1;
integer __giStateTextureFace__ = 1;
list __glStateTextures__ = [
  "texture_state_idle",
  "texture_state_running",
  "texture_state_shutting_down",
  "texture_state_paused"
];

rvApplyStateTexture(integer piState) {
  if (piState < 0 || piState > MAX_TEXTURE_INDEX) {
    return;
  }

  integer iCanApply = FALSE;
  if (!__giStateTextureCheckInventory__) {
    iCanApply = TRUE;
  } else {
    integer iCount = llGetInventoryNumber(INVENTORY_TEXTURE);
    integer i = 0;
    do {
      string sTextureName = llGetInventoryName(INVENTORY_TEXTURE, i);
      if (sTextureName == sTexture) {
        iCanApply = TRUE;
      }
      i++;
    } while (i < iCount && !iCanApply);
  }

  if (iCanApply) {
    sTexture = llList2String(STATE_TEXTURES, piState);
    llSetTexture(sTexture, __giStateTextureFace__);
  }
}

rvSetStateTextureFace(integer piFace) {
  __giStateTextureFace__ = piFace;
}

rvSetStateTextureInventoryCheck(integer piValue) {
  if (piValue == 0) {
    __giStateTextureCheckInventory__ = FALSE;
  } else {
    __giStateTextureCheckInventory__ = TRUE;
  }
}

rvSetStateTextureKey(key pkKey, integer piIndex ) {
  if (piIndex <= MAX_TEXTURE_INDEX) {
    llListReplaceList(__glStateTextures__, [pkKey], piIndex, piIndex);
  }
}

rvSetStateTextureName(string psName, integer piIndex ) {
  if (piIndex <= MAX_TEXTURE_INDEX) {
    llListReplaceList(__glStateTextures__, [psName], piIndex, piIndex);
  }
}

rvSetStateTexturesList(list plAllTextures) {
  __glStateTextures__ = plAllTextures;
}

#endif
