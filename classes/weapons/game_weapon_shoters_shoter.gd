@tool
class_name GameWeaponShotersShoter
extends GameWeaponShoter

@export_category("Shoter")
@export_enum("SHOTER","WAVE_SHOTER","LAZER_SHOTER","SHOTERS_SHOTER") var cast_class = 0
@export var properties:Dictionary = {}


#func _ready() -> void:
	#for property in propertyes:
		#print(property)

func _validate_property(property: Dictionary):
	#print(property)
	if property.name == "speed_multiplayer" or property.name == "max_modifire":
		property.usage = PROPERTY_USAGE_NONE
	if property.name == "Bullet config":
		property.name = "Casted shoter config"

func shot_soter(spawn_as_local:bool) -> void:
	if Engine.is_editor_hint(): return
	if !is_on: return
	#print("INFO| shot happend ",num)
	var marker = load("res://entity/marker_e.tscn").instantiate()
	#marker
	var soter_inst = get_node("CastShooter").get_child(0).instantiate()
	
	soter_inst.global_position = self.global_position
	var parent_node = get_tree().get_first_node_in_group("World").get_node("FunctionalEntities")
	if spawn_as_local: parent_node = get_node("."); soter_inst.position = Vector2(0,0)
	
	parent_node.add_child(soter_inst)
	return

func defalt_shot(_num:int=0) -> void:
	shot_soter(is_local)
	#print("INFO| defalt_shot")
	return

#func get_valid_poropertyes(base:Dictionary) -> Dictionary:
	#var propertyes_list := base.duplicate(true)
	#match cast_class:
		#cast_class.SHOTER:
			#if propertyes_list["aim_oppenent"] == null:
				#propertyes_list["aim_oppenent"] = false
			#if propertyes_list["is_local"] == null:
				#propertyes_list["is_local"] = false
			#if propertyes_list["is_local"] == null:
				#propertyes_list["is_local"] = false
	#
	#return propertyes_list
