extends Node2D

@onready var bullet_scene_exemplar = preload("res://entity/lazer_e.tscn")

@export_category("Lazer")
@export var direction:Vector2 = Vector2(0,0)
@onready var direction_standart:Vector2 = direction
@export var damage:float = 0.0
@export var length:float = 300.0
## если `rotation_spped` стоит на 0, то лазер не вращается

@export_category("Rotation")
@export var rotation_spped:float = 0.0
@export var rotatate_lazer:float = 0.0
@export var aim_player:bool = false

@export_category("Timer")
@export var is_on:bool = true
@export var on_timer:bool = false
@export var one_shot:bool = false
@export var cooldown:float = 1.0
@export var shoot_delay:float = 0.5
@export var delay:float = 0

@export_category("Debug")
@export var is_palyer:bool = false


func _ready() -> void:
	await get_tree().create_timer(delay).timeout
	while on_timer:
		await get_tree().create_timer(cooldown).timeout
		shot(direction,length,damage,rotatate_lazer,rotation_spped,aim_player,shoot_delay)


func aim_player_f():
	#print("aim_player_f")
	if aim_player:
		direction = Vector2(1.0,0.0) + direction_standart
		look_at(get_tree().get_first_node_in_group("Player").position)

func shot(lazer_direction:Vector2=Vector2(0,0),lazer_length:float=10,lazer_damage:float=0.0,lazer_rotation:float=0.0,lazer_rotation_spped:float=0.0,lazer_aim_player:bool=true,lazer_shoot_delay:float=0):
	if !is_on: return
	var lazer = bullet_scene_exemplar.instantiate()
	if is_palyer:
		lazer.get_node("RayCast").set_collision_mask(6)
		if get_tree().get_first_node_in_group("Boss") != null:
			lazer.direction = (get_tree().get_first_node_in_group("Boss").global_position - global_position).normalized()
		else:
			return
	else: 
		aim_player_f()
		lazer.get_node("RayCast").set_collision_mask(5)
		#lazer.direction = ($Marker.global_position - global_position).normalized() * lazer_direction
		lazer.add_rotation = lazer_rotation
	#print(bullet.get_node("Components/XitboxArea_C").get_collision_mask())
	if !aim_player:
		lazer.direction = lazer_direction
	lazer.length = lazer_length
	lazer.damage = lazer_damage
	lazer.rotation_spped = lazer_rotation_spped
	lazer.global_position = global_position
	lazer.one_shot = true
	lazer.rotation = lazer_rotation
	lazer.aim_player = lazer_aim_player
	lazer.shoot_delay = lazer_shoot_delay
	#print("")
	#print("lazer_length:        ",lazer.length)
	#print("lazer_direction:     ",lazer_direction)
	#print("lazer_length*bul_dir:",lazer.direction*lazer_length)
	#print("().normalized:       ",($Marker.global_position - global_position).normalized())
	#print("Marker gpos | gpos:  ",$Marker.global_position,"|",global_position)
	
	get_tree().get_first_node_in_group("World").get_node("FunctionalEntities").add_child(lazer)
	if one_shot: queue_free()
