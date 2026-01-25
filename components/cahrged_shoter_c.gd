extends Node2D

@onready var bullet_scene_exemplar = preload("res://entity/bullet_e.tscn")

@export var direction:Vector2 = Vector2(0,0)
@export var speed:float = 300
@export var damage:float = 1.0
@export var one_shot:bool = false
@export var aim_player:bool = false

@export var is_palyer:bool = false

@export_category("Timer")
##для этого компонента, `on_timer` ничего не делает
@export var on_timer:bool = false

@export_category("Fun")
## если `true` пули призываются в компоненте... вызывает интересные... "результаты"
@export var local_bullets:bool = false

var charge_time:float = 0

func aim_player_f():
	#print("aim_player_f")
	if aim_player:
		direction = Vector2(1.0,0.0)
		look_at(get_tree().get_first_node_in_group("Player").position)

func shot(bullet_direction:Vector2=Vector2(0,0),bullet_speed:float=300,bullet_damage:float=0.0):
	var bullet = bullet_scene_exemplar.instantiate()
	if is_palyer:
		bullet.get_node("Components/XitboxArea_C").set_collision_mask(6)
		if get_tree().get_first_node_in_group("Boss") != null:
			bullet.velocity = (get_tree().get_first_node_in_group("Boss").global_position - global_position).normalized()*bullet_speed
		else:
			return
	else: 
		aim_player_f(); bullet.get_node("Components/XitboxArea_C").set_collision_mask(5)
		bullet.velocity = ($Marker.global_position - global_position).normalized()*bullet_speed+bullet_direction
	#print(bullet.get_node("Components/XitboxArea_C").get_collision_mask())
	bullet.direction_ = bullet_direction
	bullet.speed_ = bullet_speed
	bullet.damage = bullet_damage
	bullet.global_position = global_position
	if local_bullets:
		add_child(bullet)
	else:
		get_tree().get_first_node_in_group("World").get_node("FunctionalEntities").add_child(bullet)
	if one_shot: get_tree().quit()

func _ready() -> void:
	#print(get_node("../.."))
	if get_node("../..").get_name() == "Player_E": is_palyer = true
	else: is_palyer = false

func _process(delta: float) -> void:
	#print(charge_time)
	if Input.is_action_just_pressed("shot"):
		charge_time = 0
	if Input.is_action_pressed("shot"):
		charge_time += delta*2
	if Input.is_action_just_released("shot"):
		shot(direction,clamp(speed*charge_time,speed*0.01,speed*3),clamp(damage*charge_time,damage*0.01,damage*3))
		charge_time = 0
		
	
	if !is_palyer:
		aim_player_f()
