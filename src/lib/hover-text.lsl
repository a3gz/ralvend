#ifndef RV_HOVER_TEXT
#define RV_HOVER_TEXT

vector __gvHoverTextColor__ = <1.0, 1.0, 1.0>;
float __gfHoverTextAlpha__ = 1.0;

rvCleanHoverText() {
  llSetText("", ZERO_VECTOR, 0.0);
}

rvSetHoverText(string psText) {
  llSetText(psText, __gvHoverTextColor__, __gfHoverTextAlpha__);
}

rvSetHoverTextAlpha(float pfAlpha) {
  __gfHoverTextAlpha__ = pfAlpha;
}

rvSetHoverTextColor(vector pvColor) {
  __gvHoverTextColor__ = pvColor;
}

#endif
