extends GameMenuButton


func _toggled(_toggled_on: bool) -> void:
	super(_toggled_on)
	
func _process(_delta: float) -> void:
	if G.selected_weapons.size() <= 0:
		disabled = true
	else:
		disabled = false
	super(_delta)
