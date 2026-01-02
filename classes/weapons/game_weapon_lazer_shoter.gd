## Класс для всех стрелков лазерами
class_name GameWeaponLazerShoter
extends GameWeaponShoter

## конфиг конкретно связанные с лазером
@export_category("Lazer")
## по простому - скорость лазера
@export var cast_delay:float = 1.0
## поворачивает лазер на заданное кол-во градусов
@export var cast_rotation:float = 0
## нормолизированный процент cast_delay после которого лазер перестаёт следовать за опонентом
@export_range(0,1,0.005) var stop_follow:float = 1.0
## ширена лазера
@export var width:int = 10


func lazer_shot(lazer:Resource,lazer_direction:Vector2,lazer_speed:float,lazer_damage:float,
				lazer_cast_delay:float,lazer_stop_follow:float=1.0,
				lazer_width:int=10,lazer_cast_rotation:float=0.0,is_targeting_opponent:bool=false,
				spawn_as_local:bool=false) -> void:
	if !is_on: return
	var lazer_inst = lazer.instantiate()
	
	lazer_inst.global_position = self.global_position
	var parent_node = get_tree().get_first_node_in_group("World").get_node("FunctionalEntities")
	if spawn_as_local: parent_node = get_node("."); lazer_inst.position = Vector2(0,0)
	lazer_inst.get_node("RayCast").set_collision_mask(get_bullet_collision())
	lazer_inst.get_node("RayCast").target_position = lazer_direction*lazer_speed
	lazer_inst.cast_delay = lazer_cast_delay
	lazer_inst.cast_rotation = lazer_cast_rotation
	lazer_inst.get_node("Shape").width = lazer_width
	if is_targeting_opponent:
		lazer_inst.get_node("RayCast").target_position = ((get_oppenent().global_position-self.global_position).normalized())*lazer_speed
		if spawn_as_local:
			lazer_inst.get_node("RayCast").target_position = (((get_oppenent().global_position-self.global_position).normalized())*lazer_speed)-global_position
			lazer_inst.is_local = true
		lazer_inst.aim_oppenent = true
		lazer_inst.oppenent = get_oppenent()
		lazer_inst.length = lazer_speed
		lazer_inst.stop_follow = lazer_stop_follow
	lazer_inst.damage = lazer_damage
	
	parent_node.add_child(lazer_inst)
	
func defalt_shot(_num:int=0) -> void:
	lazer_shot(bullet_scene,direction,speed*get_entity_speed_modifire(),damage*get_entity_speed_modifire(),cast_delay,stop_follow,width,cast_rotation,aim_oppenent,is_local)
