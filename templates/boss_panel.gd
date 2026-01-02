@tool
extends Panel

@export var icon:Texture2D
@export var _title:String = ""
@export_multiline() var description:String = ""

@onready var unknow:Texture2D = load("res://assets/textures/bosses_icon/unknow.png")

@onready var og_size = size
func _ready() -> void:
	#if Engine.is_editor_hint():
		#size = og_size 
	$VSplitContainer/Header/Icon.texture = icon
	$VSplitContainer/Header/Title.text = _title
	$VSplitContainer/Description.text = description

func _process(_delta: float) -> void:
	if $VSplitContainer/Header/Title.text != _title:
		$VSplitContainer/Header/Title.text = _title
	if $VSplitContainer/Description.text != description:
		$VSplitContainer/Description.text = description
	if !Engine.is_editor_hint():
		if G.win_to or G.died_to: $VSplitContainer/Header/Icon.texture = icon
		else: $VSplitContainer/Header/Icon.texture = unknow
	else:
		if $VSplitContainer/Header/Icon.texture != icon:
			$VSplitContainer/Header/Icon.texture = icon
