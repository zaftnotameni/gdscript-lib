class_name Zaft_Primitive_BackgroundColorWithRect extends ColorRect

@export var layer : Zaft_Autoload_Layers.LAYERS = Zaft_Autoload_Layers.LAYERS.background

func at_layer(target:=Zaft_Autoload_Layers.LAYERS.background) -> Zaft_Primitive_BackgroundColorWithRect:
  layer = target
  return self

func with_material(sm:ShaderMaterial) -> Zaft_Primitive_BackgroundColorWithRect:
  material = sm
  return self

func add_to_tree() -> Zaft_Primitive_BackgroundColorWithRect:
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
