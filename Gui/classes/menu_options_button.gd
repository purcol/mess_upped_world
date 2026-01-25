@tool
class_name GameMenuOptionsButton
extends GameMenuButton


func _process(_delta: float) -> void:
	super(_delta)
	focus_mode = Control.FOCUS_NONE
	if !Engine.is_editor_hint():
		if is_hovered() and !disabled or G.settings[settings_list[flip_setting]]:
			$Control/SelectionArrow.visible = true
		else:
			$Control/SelectionArrow.visible = false
