@tool
class_name Z_InputIconControl extends TextureRect

@export var k : Z_InputKey.K = Z_InputKey.K.Space

func on_editor_save_setup():
  texture = Z_InputKey.outline_image_for(k)
