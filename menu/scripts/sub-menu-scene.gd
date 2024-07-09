class_name Zaft_Submenu_Node extends Container

@export var sections : Array[PackedScene]
@export var title : String = ""

@onready var panel := PanelContainer.new()
@onready var margin := MarginContainer.new()
@onready var lbl_title := Label.new()
@onready var vbox_layout := VBoxContainer.new()
@onready var vbox_sections := VBoxContainer.new()
@onready var closer : Zaft_Closer_Button = Zaft_Closer_Button.new()

func _ready() -> void:
  add_to_group("closeable")

  panel.set_anchors_preset(PRESET_FULL_RECT)
  margin.set_anchors_preset(PRESET_FULL_RECT)
  vbox_layout.set_anchors_preset(PRESET_FULL_RECT)
  vbox_sections.set_anchors_preset(PRESET_FULL_RECT)

  vbox_sections.grow_vertical = Control.GROW_DIRECTION_BOTH
  vbox_sections.size_flags_vertical = Control.SIZE_EXPAND_FILL

  for s:PackedScene in sections:
    vbox_sections.add_child(s.instantiate())

  if title and not title.is_empty():
    lbl_title.text = title
    lbl_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    lbl_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    Zaft_Autoload_Util.control_set_color(lbl_title,Color.WHITE)
    Zaft_Autoload_Util.control_set_font_size(lbl_title,64)

    vbox_layout.add_child(lbl_title)

  vbox_layout.add_child(vbox_sections)
  vbox_layout.add_child(closer)

  margin.add_child(vbox_layout)
  panel.add_child(margin)
  add_child(panel)
