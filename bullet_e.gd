extends CharacterBody2D

@export var direction_:Vector2 = Vector2(0,0)
@export var speed_:float = 300
@export var damage:float = 1.0

var target_player:bool = false

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#velocity = direction_ *speed_

func _physics_process(_delta: float) -> void:
	move_and_slide()

#func _on_timer_timeout() -> void:
	#$RayCast.force_raycast_update()
	#if $RayCast.get_collider() != null:
		#if $RayCast.get_collider().get_name() == "XitboxArea_C":
			#target_player = $RayCast.get_collider().is_player()
		#if target_player:
			#$RayCast.get_collider().hit(1)
			#print("!")
			#
	#if one_shot:
		#queue_free()


func _on_xitbox_area_c_area_entered(area: Area2D) -> void:
	#print(area.entity_id)
	if area.entity_id == "Bullet_E":
		return
	if area.get_name() == "XitboxArea_C":
		target_player = area.is_player()
	area.hit(damage)
	if target_player:
		print("!")
	queue_free()
