@tool
class_name Z_InputIconControl extends TextureRect

func _enter_tree() -> void:
	stretch_mode = StretchMode.STRETCH_KEEP_ASPECT_CENTERED

func with_texture(tex:Texture2D) -> Z_InputIconControl:
	texture = tex
	return self

func with_name(n:String) -> Z_InputIconControl:
	name = n
	return self
