class_name Z_InputKey extends Node

static func outline_image_for(k:K) -> Texture2D:
  return Gen_AllImages['IMAGE_KEYBOARD_%s_OUTLINE' % K.find_key(k).to_snake_case().to_upper()]

enum K {
  None = 0,
  W = KEY_W,
  A = KEY_A,
  S = KEY_S,
  D = KEY_D,
  R = KEY_R,
  C = KEY_C,
  X = KEY_X,
  Q = KEY_Q,
  E = KEY_E,
  F = KEY_F,
  P = KEY_P,
  H = KEY_H,
  J = KEY_J,
  K = KEY_K,
  L = KEY_L,
  M = KEY_M,
  O = KEY_O,
  Space = KEY_SPACE,
  Shift = KEY_SHIFT,
  Ctrl = KEY_CTRL,
  Alt = KEY_ALT,
  Escape = KEY_ESCAPE,
  ArrowDown = KEY_DOWN,
  ArrowUp = KEY_UP,
  ArrowLeft = KEY_LEFT,
  ArrowRight = KEY_RIGHT,
}
