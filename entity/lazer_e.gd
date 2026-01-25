extends Node2D

var damage:float = 1.0
var cast_delay:float = 0.5
var stop_follow:float = 1.0
var aim_oppenent:bool = false
var oppenent:Node
#var direction:Vector2 = Vector2(0,0)
var cast_rotation:float = 0.0
@onready var defalt_rotation:float = rotation_degrees
var length:float = 0.0
var is_local:bool = false

func hit(lazzer_damage:float=1.0) -> void:
	$RayCast.enabled = true
	$RayCast.force_shapecast_update()
	
	if !$RayCast.is_colliding(): return
		#if $RayCast.get_collider(collider_index).get_name() == "XitboxArea_C" and $RayCast.get_collider(collider_index).get_node("../..").is_in_groop(""):
	for collider_index in range($RayCast.get_collision_count()):
		if $RayCast.get_collider(collider_index) != null:
			#print($RayCast.get_collider(collider_index).get_name())
			$RayCast.get_collider(collider_index).hit(lazzer_damage*0.5)

func stop_aim() -> void:
	await get_tree().create_timer(cast_delay*stop_follow).timeout
	aim_oppenent = false
	if is_local:
		defalt_rotation = get_node("../../../..").rotation_degrees

func _ready() -> void:
	stop_aim()
	await get_tree().create_timer(cast_delay*0.8).timeout
	hit(damage)
	$Shape.is_flikering = false
	$Shape.default_color = Color(1,1,1,1)
	await get_tree().create_timer(cast_delay*0.2).timeout
	queue_free()

func _physics_process(_delta: float) -> void:
	#queue_redraw()
	if aim_oppenent:
		$RayCast.target_position = (((oppenent.global_position-self.global_position).normalized())*length)#-global_position
		if is_local:
			rotation_degrees = -get_node("../../../..").rotation_degrees + cast_rotation
		else:
			rotation_degrees = defalt_rotation + cast_rotation
	elif is_local:
		rotation_degrees = defalt_rotation+(-get_node("../../../..").rotation_degrees-defalt_rotation)
		#rotation = deg_to_rad(defalt_rotation)+(-get_node("../../../..").rotation-deg_to_rad(defalt_rotation))

#func _draw() -> void:
	#draw_arc(position,360,0,deg_to_rad(defalt_rotation)+(get_node("../../../..").rotation-deg_to_rad(defalt_rotation)),100,Color.PURPLE,3)
	#draw_arc(position,330,0,get_node("../../../..").rotation-deg_to_rad(defalt_rotation),100,Color.WEB_PURPLE,3)
	#draw_arc(position,300,0,deg_to_rad(defalt_rotation),100,Color.BURLYWOOD,3)
	#draw_arc(position,250,0,-rotation,100,Color.POWDER_BLUE,3)
	#draw_arc(position,200,0,get_node("../../../..").rotation,100,Color.WHEAT,3)
