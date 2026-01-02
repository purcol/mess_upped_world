@tool
extends GameMenuButton


func _toggled(_toggled_on: bool) -> void:
	if !Engine.is_editor_hint():
		G.selected_boss = G.BossesID.LAZER_TAG_BOSS_E
	super(_toggled_on)
	
func _process(_delta: float) -> void:
	super(_delta)
