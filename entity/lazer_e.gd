extends Node2D

@export var direction:Vector2 = Vector2(0,0)
@export var damage:float = 0.0
@export var length:float = 0.0
@export var rotation_spped:float = 0.0
@export var add_rotation:float = 0.0
@export var aim_player:bool = false

@export_category("Timer")
@export var on_timer:bool = true
@export var one_shot:bool = false
@export var cooldown:float = 1.0
@export var shoot_delay:float = 0.5

var target_player:bool = false
var clolor:Color = Color.DARK_GRAY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if on_timer:
		$Timer.start(cooldown)
	$RayCast.target_position = direction*length
	$Line2D.points[1] = $RayCast.target_position

func _process(_delta: float) -> void:
	$Line2D.default_color = Color.DARK_GRAY
	if aim_player:
		direction = Vector2(1.0,0.0)
		if get_tree().get_first_node_in_group("Player") != null:
			look_at(get_tree().get_first_node_in_group("Player").position)
		rotation_degrees += add_rotation

func _on_timer_timeout() -> void:
	if aim_player:
		aim_player = false
	get_tree().create_tween().tween_property($Line2D,"default_color",Color.WHITE,shoot_delay*2)
	get_tree().create_tween().tween_property($Line2D,"width",20,shoot_delay*2)
	$CooldownTimer.start(shoot_delay)

func _on_cooldown_timer_timeout() -> void:
	aim_player = true
	clolor = Color.DARK_GRAY
	$RayCast.force_shapecast_update()
	if $RayCast.is_colliding():
		if $RayCast.get_collider(0).get_name() == "XitboxArea_C":
			target_player = $RayCast.get_collider(0).is_player()
		if target_player:
			$RayCast.get_collider(0).hit(1)
	queue_free()
