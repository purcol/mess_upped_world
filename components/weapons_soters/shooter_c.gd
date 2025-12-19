extends Node2D

@onready var bullet_scene_exemplar = preload("res://entity/bullet_e.tscn")

@export_category("Bullet")
@export var direction:Vector2 = Vector2(0,0)
@onready var direction_standart:Vector2 = direction
@export var speed:float = 300
@export var speed_modificator:float = 0.0
@export var damage:float = 0.0
@export var aim_player:bool = false

@export_category("Timer")
@export var is_on:bool = true
@export var on_timer:bool = false
@export var one_shot:bool = false
@export var cooldown:float = 1.0

@export_category("Fun")
## если `true` пули призываются в компоненте... вызывает интересные... "результаты"
@export var local_bullets:bool = false

@export_category("Debug")
@export var is_palyer:bool = false


func aim_player_f():
	#print("aim_player_f")
	if aim_player:
		direction = Vector2(1.0,0.0) + direction_standart
		if get_tree().get_first_node_in_group("Player") != null:
			look_at(get_tree().get_first_node_in_group("Player").position)

func shot(bullet_direction:Vector2=Vector2(0,0),bullet_speed:float=300,bullet_modificator:float=0.0,bullet_damage:float=0.0):
	if !is_on: return
	var bullet = bullet_scene_exemplar.instantiate()
	if is_palyer:
		bullet.get_node("Components/XitboxArea_C").set_collision_mask(6)
		if get_tree().get_first_node_in_group("Boss") != null:
			bullet.velocity = ((get_tree().get_first_node_in_group("Boss").global_position - global_position).normalized()*(bullet_speed+(bullet_speed*bullet_modificator)))
		else:
			return
	else: 
		aim_player_f()
		bullet.get_node("Components/XitboxArea_C").set_collision_mask(5)
		bullet.velocity = (($Marker.global_position - global_position).normalized()*(bullet_speed+(bullet_speed*bullet_modificator)))
		#print("")
		#print("velocity:        ",bullet.velocity)
		#print("bullet_direction:",bullet_direction)
		#print("velocity*bul_dir:",bullet.velocity*bullet_direction)
	#print(bullet.get_node("Components/XitboxArea_C").get_collision_mask())
	bullet.direction_ = bullet_direction
	bullet.speed_ = bullet_speed+(bullet_speed*bullet_modificator)
	#print(bullet.speed_)
	bullet.damage = bullet_damage
	bullet.global_position = global_position
	if local_bullets:
		bullet.position = Vector2.ZERO
		add_child(bullet)
	else:
		get_tree().get_first_node_in_group("World").get_node("FunctionalEntities").add_child(bullet)
	if one_shot: queue_free()

func _ready() -> void:
	#print(get_node("../.."))
	if get_node("../..").get_name() == "Player_E": is_palyer = true
	else: is_palyer = false
	if on_timer: $Timer.start(cooldown)
		

func _process(_delta: float) -> void:
	if !is_palyer:
		aim_player_f()
	var new_speed_modificator = speed_modificator
	if get_node("../Healf_C") != null:
		new_speed_modificator = (1-(get_node("../Healf_C").healf/get_node("../Healf_C").max_healf))*speed_modificator
	#if get_node("../..").name == "Player_E":
		#print(cooldown,"|",new_speed_modificator,"|",cooldown-(cooldown*new_speed_modificator))
	$Timer.wait_time = cooldown-(cooldown*new_speed_modificator)

func _on_timer_timeout() -> void:
	if !is_on: return
	var new_speed_modificator = speed_modificator
	if get_node("../Healf_C") != null:
		new_speed_modificator = speed_modificator/(get_node("../Healf_C").healf/get_node("../Healf_C").max_healf)
	shot(direction,speed,new_speed_modificator,damage)
	#print(speed_modificator)
	#print(direction.normalized())
