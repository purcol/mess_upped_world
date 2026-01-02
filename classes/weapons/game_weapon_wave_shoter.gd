@tool
class_name GameWeaponWaveShoter
extends GameWeaponShoter

@export_category("Wave Config")
@export var duration:float = 1.0
@export var wait_after_time_out_time:float = 0.0

func wave_shot(wave:Resource,_wave_direction:Vector2,_wave_speed:float,wave_damage:float,
		wave_duration:float,wave_wait_after_time_out_time:float,
		_is_targeting_opponent:bool=false,spawn_as_local:bool=false,_num:int=-1) -> void:
	if Engine.is_editor_hint(): return
	if !is_on: return
	#print("INFO| shot happend ",num)
	var wave_inst = wave.instantiate()
	
	wave_inst.global_position = self.global_position
	var parent_node = get_tree().get_first_node_in_group("World").get_node("FunctionalEntities")
	if spawn_as_local: parent_node = get_node("."); wave_inst.position = Vector2(0,0)
	wave_inst.get_node("Components/XitboxArea_C").set_collision_mask(get_bullet_collision())
	wave_inst.damage = wave_damage
	wave_inst.velocity = Vector2.ZERO
	wave_inst.duration = wave_duration
	wave_inst.wait_after_time_out_time = wave_wait_after_time_out_time
	
	parent_node.add_child(wave_inst)
	return

func defalt_shot(num:int=0) -> void:
	wave_shot(bullet_scene,Vector2(0,0),0,damage*get_entity_speed_modifire(),duration,wait_after_time_out_time,false,is_local,num)
	#print("INFO| defalt_shot")
	return

func shot_condition() -> void:
	if Input.is_action_just_pressed("shot"):
		shot_condition_flag = true
	else: shot_condition_flag = false

func _validate_property(property: Dictionary):
	#print(property)
	if property.name == "direction" or property.name == "speed" or property.name == "aim_oppenent":
		property.usage = PROPERTY_USAGE_NONE
