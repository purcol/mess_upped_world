class_name SimpleAchiementButton
extends GameMenuButton

var is_unlocked:bool = false

func unlock_condision() -> void:
	pass

func _toggled(_toggled_on: bool) -> void:
	super(_toggled_on)
	
func _process(_delta: float) -> void:
	unlock_condision()
	if !is_unlocked: disabled = true
	else: disabled = false
	super(_delta)
