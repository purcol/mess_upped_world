@tool
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
##офсет при наводке (если aiming_offset = (0.0,0.0) не рабоает)
@export var attack_path:String = ""

func get_ally() -> Node:
	var ally:Node
	if is_palyer:
		ally = get_tree().get_first_node_in_group("Player")
	else:
		if attack_path != "" and get_tree().get_first_node_in_group("Boss") != null: ally = get_tree().get_first_node_in_group("Boss").get_node("Components/"+attack_path)
		else: ally = get_tree().get_first_node_in_group("Boss")
	if ally == null: ally = get_tree().get_first_node_in_group("World"); push_warning("Warning | Ally is null!")
	#print(ally,"  ", aim)
	return ally

func lazer_shot(lazer:Resource,lazer_direction:Vector2,lazer_speed:float,lazer_damage:float,
				lazer_cast_delay:float,lazer_stop_follow:float=1.0,
				lazer_width:int=10,lazer_cast_rotation:float=0.0,targeting:int=0,
				spawn_as_local:bool=false) -> void:
	if Engine.is_editor_hint(): return
	if !is_on: return
	#print("!lazer_shot ", self.get_path())
	on_shot.emit()
	var lazer_inst = lazer.instantiate()
	
	lazer_inst.global_position = self.global_position
	var parent_node = get_tree().get_first_node_in_group("World").get_node("FunctionalEntities")
	if spawn_as_local: parent_node = get_node("."); lazer_inst.position = Vector2(0,0)
	lazer_inst.get_node("RayCast").set_collision_mask(get_bullet_collision())
	lazer_inst.get_node("RayCast").target_position = lazer_direction*lazer_speed
	lazer_inst.cast_delay = lazer_cast_delay
	lazer_inst.cast_rotation = lazer_cast_rotation
	lazer_inst.get_node("Shape").width = lazer_width
	#if targeting == 1:
	lazer_inst.get_node("RayCast").target_position = ((get_target(targeting).global_position-self.global_position).normalized())*lazer_speed
	if use_predict: lazer_inst.get_node("RayCast").target_position = ((get_predicted_location(targeting)-self.global_position).normalized())*lazer_speed
	if spawn_as_local:
		lazer_inst.get_node("RayCast").target_position -= global_position #(((get_target(targeting).global_position-self.global_position).normalized())*lazer_speed)
		lazer_inst.is_local = true
	lazer_inst.aim_oppenent = true
	lazer_inst.oppenent = get_target(targeting)
	lazer_inst.length = lazer_speed
	lazer_inst.stop_follow = lazer_stop_follow
	#if targeting == 2:
		#lazer_inst.get_node("RayCast").target_position = ((get_target(targeting).global_position-self.global_position).normalized())*lazer_speed
		#if spawn_as_local:
			#lazer_inst.get_node("RayCast").target_position = (((get_target(targeting).global_position-self.global_position).normalized())*lazer_speed)-global_position
			#lazer_inst.is_local = true
		#lazer_inst.aim_oppenent = true
		#lazer_inst.oppenent = get_target(targeting)
		#lazer_inst.length = lazer_speed
		#lazer_inst.stop_follow = lazer_stop_follow
	lazer_inst.damage = lazer_damage
	
	parent_node.add_child(lazer_inst)
	if one_shot: self.queue_free(); return
	
func defalt_shot(_num:int=0) -> void:
	lazer_shot(bullet_scene,direction,speed,damage*get_entity_speed_modifire(),cast_delay,stop_follow,width,cast_rotation,aim,is_local)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_dashed_line(Vector2.ZERO,(Vector2(1,1).rotated(deg_to_rad(cast_rotation))).normalized()*speed,Color.ORANGE,1)
