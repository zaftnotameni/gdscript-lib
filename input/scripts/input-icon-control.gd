@tool
class_name Z_InputIconControl extends TextureRect

@export var k : Z_InputKey.K = Z_InputKey.K.None

func on_editor_save_setup():
  if k == Z_InputKey.K.None: return
  texture = Z_InputKey.outline_image_for(k)

static func with_texture(tex:Texture2D) -> Z_InputIconControl:
  var res = Z_InputIconControl.new()
  res.texture = tex
  return res
