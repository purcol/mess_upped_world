@tool
class_name GameMenuWeaponButton
extends GameMenuButton

@export_category("Weapon Button")
#components/wapons
@export var weapon:Resource = load("res://components/weapons_shoters/shoter_c.tscn")
var weapon_name:String = ""

func _ready() -> void:
	if !Engine.is_editor_hint():
		weapon_name = (weapon.resource_path)
		G.print_log("ButtonInit",["weapon's in "+name+" path:         ",weapon_name])
		#print("INFO| weapon's in "+name+" path:         ",weapon_name)
		weapon_name = (weapon.resource_path).replace("res://components/weapons_shoters/",""); weapon_name = weapon_name.replace("_c.tscn","")
		G.print_log("ButtonInit",["weapon's in "+name+" cleared name: ",weapon_name])
		#print("INFO| weapon's in "+name+" cleared name: ",weapon_name)
	
func _toggled(_toggled_on: bool) -> void:
	if !Engine.is_editor_hint():
		if G.selected_weapons.has(weapon_name):
			G.earese_from_restricted(weapon_name)
			G.selected_weapons.erase(weapon_name)
		else:
			if needs_weapons: G.selected_restricted_weapons["passive"] = weapon_name
			else: G.selected_restricted_weapons["active"] = weapon_name
			G.selected_weapons.append(weapon_name)
	focus_mode = Control.FOCUS_NONE

func _process(_delta: float) -> void:
	super(_delta)
	focus_mode = Control.FOCUS_NONE
	if !Engine.is_editor_hint():
		if is_hovered() and !disabled or G.selected_weapons.has(weapon_name):
			$Control/SelectionArrow.visible = true
		else:
			$Control/SelectionArrow.visible = false
