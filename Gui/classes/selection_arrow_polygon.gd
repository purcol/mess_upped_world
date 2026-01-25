class_name SelectionArrow
extends Polygon2D

#должна ли стрелка мигать
var filker:bool = true
#мигает ле стрелка
var is_flikering:bool = false
var can_fliker:bool = true

func _ready() -> void:
	offset = Vector2(10.667, 2.667)
	polygon = PackedVector2Array([Vector2(-10.667,-2.667),Vector2(-5.333,-13.333),Vector2(-16.0,-13.333)])
	position = Vector2(49.333,9.333)
	rotation_degrees = 90
	scale = Vector2(0.813,0.813)

func _process(_delta: float) -> void:
	if !is_flikering and filker and can_fliker:
		is_flikering = true
		$Timer.start()
	if !filker or !can_fliker:
		$Timer.stop()
		self_modulate = Color.WHITE
		is_flikering = false

func _on_timer_timeout() -> void:
	self_modulate = Color(1,1,1,0) if self_modulate==Color.WHITE else Color.WHITE
