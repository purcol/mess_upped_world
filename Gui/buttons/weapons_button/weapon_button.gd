@tool
##кнопка ипользуемая для достижений.
@icon("res://assets/textures/node_icons/weapon_icon.png")
class_name WeaponButton
extends BasicButton

@export_enum("SHOTER","CHARGER_SHOTER","SHOTERS_SHOTER","LAZER","LAZER_MINE") var WEAPON = 0

func is_unlocked() -> bool: return Engine.is_editor_hint()

func _process(_delta: float) -> void:
	super._process(_delta)
	if Engine.is_editor_hint(): return
	if has_node("./Panel"): WEAPON = get_node("./Panel").WEAPON
	$Equiped.visible = GWeapons.is_equiped(WEAPON)
