class_name Z_Primitive_BackgroundColorWithRect extends ColorRect

@export var layer : Z_Autoload_Layers.LAYERS = Z_Autoload_Layers.LAYERS.background
@export var auto_parallax : Vector2

func hidden(is_hidden:=false) -> Z_Primitive_BackgroundColorWithRect:
  visible = not is_hidden
  return self

func at_layer(target:=Z_Autoload_Layers.LAYERS.background) -> Z_Primitive_BackgroundColorWithRect:
  layer = target
  return self

func with_material(sm:ShaderMaterial, parallax:=Vector2.ZERO) -> Z_Primitive_BackgroundColorWithRect:
  auto_parallax = parallax
  sm.set_shader_parameter('parallax_auto', auto_parallax)
  material = sm
  return self

func add_to_tree() -> Z_Primitive_BackgroundColorWithRect:
  assert(layer, 'layer must be set')
  assert(material, 'material must be set')
  __zaft.layer.layer_named(layer).add_child(self)
  return self

func _enter_tree() -> void:
  add_to_group(__zaft.path.MAIN_CAMERA_PARALLAX_GROUP)
  texture_repeat = TextureRepeat.TEXTURE_REPEAT_ENABLED
  mouse_filter = MOUSE_FILTER_IGNORE

func _ready() -> void:
  set_anchors_and_offsets_preset(LayoutPreset.PRESET_FULL_RECT, LayoutPresetMode.PRESET_MODE_KEEP_SIZE)
