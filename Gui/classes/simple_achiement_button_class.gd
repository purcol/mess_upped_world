@tool
class_name SimpleAchiementButton
extends GameMenuButton

var is_unlocked:bool = false

func _toggled(_toggled_on: bool) -> void:
	super(_toggled_on)
	
func _process(_delta: float) -> void:
	super(_delta)

func unlock_check() -> bool:
	return true

func disable_check() -> bool:
	if !Engine.is_editor_hint():
		if !unlock_check():
			return true
	return super()
