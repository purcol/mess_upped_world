@tool
@icon("res://assets/textures/node_icons/weapon_panel_icon.png")
class_name WeaponSubPanel
extends BasicItemSubpanel

@export_enum("SHOTER","CHARGER_SHOTER","SHOTERS_SHOTER","LAZER","LAZER_MINE") var WEAPON = 0

func _ready() -> void:
	path_desc = "./VSplit/VSplit/Description"

func _process(_delta: float) -> void:
	super._process(_delta)
	$VSplit/VSplit/HSplit/Equip.WEAPON = WEAPON
