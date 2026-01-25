@tool
extends Panel

@export var icon:Texture2D
@export var _title:String = ""
@export_multiline() var description:String = ""

func _ready() -> void:
	if !Engine.is_editor_hint():
		$VSplitContainer/Header/Icon.texture = icon
		$VSplitContainer/Header/Title.text = _title
		$VSplitContainer/Description.text = description

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if $VSplitContainer/Header/Title.text != _title:
			$VSplitContainer/Header/Title.text = _title
		if $VSplitContainer/Description.text != description:
			$VSplitContainer/Description.text = description
		if $VSplitContainer/Header/Icon.texture != icon:
			$VSplitContainer/Header/Icon.texture = icon
