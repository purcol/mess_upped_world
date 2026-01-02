extends Camera2D

@export var speed:float = 10
var target:Vector2 = Vector2.ZERO
var is_locked:bool = false

func mouse_move() -> void:
	#print(get_local_mouse_position())
	if get_local_mouse_position().y >= 500:
		position.y += speed
		get_tree().create_tween().tween_property($DownArrow, "color",  $"..".active_color, 0.1)
		get_tree().create_tween().tween_property($Help, "modulate",  Color(1,1,1,0), 0.5)
	else: get_tree().create_tween().tween_property($DownArrow, "color",  $"..".unactive_color, 0.1)
	if get_local_mouse_position().y <= -500:
		position.y -= speed
		get_tree().create_tween().tween_property($UpArrow, "color",  $"..".active_color, 0.1)
		get_tree().create_tween().tween_property($Help, "modulate",  Color(1,1,1,0), 0.5)
	else: get_tree().create_tween().tween_property($UpArrow, "color",  $"..".unactive_color, 0.1)
	if get_local_mouse_position().x >= 900:
		position.x += speed
		get_tree().create_tween().tween_property($RightArrow, "color",  $"..".active_color, 0.1)
		get_tree().create_tween().tween_property($Help, "modulate",  Color(1,1,1,0), 0.5)
	else: get_tree().create_tween().tween_property($RightArrow, "color",  $"..".unactive_color, 0.1)
	if get_local_mouse_position().x <= -900:
		position.x -= speed
		get_tree().create_tween().tween_property($LeftArrow, "color",  $"..".active_color, 0.1)
		get_tree().create_tween().tween_property($Help, "modulate",  Color(1,1,1,0), 0.5)
	else: get_tree().create_tween().tween_property($LeftArrow, "color",  $"..".unactive_color, 0.1)

func keyboard_move() -> void:
	if Input.is_action_pressed("down"):
		position.y += speed*1.5
		get_tree().create_tween().tween_property($DownArrow, "color",  $"..".active_color, 0.1)
		get_tree().create_tween().tween_property($Help, "modulate",  Color(1,1,1,0), 0.5)
	else: get_tree().create_tween().tween_property($DownArrow, "color",  $"..".unactive_color, 0.1)
	if Input.is_action_pressed("up"):
		position.y -= speed*1.5
		get_tree().create_tween().tween_property($UpArrow, "color",  $"..".active_color, 0.1)
		get_tree().create_tween().tween_property($Help, "modulate",  Color(1,1,1,0), 0.5)
	else: get_tree().create_tween().tween_property($UpArrow, "color",  $"..".unactive_color, 0.1)
	if Input.is_action_pressed("right"):
		position.x += speed*1.5
		get_tree().create_tween().tween_property($RightArrow, "color",  $"..".active_color, 0.1)
		get_tree().create_tween().tween_property($Help, "modulate",  Color(1,1,1,0), 0.5)
	else: get_tree().create_tween().tween_property($RightArrow, "color",  $"..".unactive_color, 0.1)
	if Input.is_action_pressed("left"):
		position.x -= speed*1.5
		get_tree().create_tween().tween_property($LeftArrow, "color",  $"..".active_color, 0.1)
		get_tree().create_tween().tween_property($Help, "modulate",  Color(1,1,1,0), 0.5)
	else: get_tree().create_tween().tween_property($LeftArrow, "color",  $"..".unactive_color, 0.1)

func _process(_delta: float) -> void:
	if !is_locked:
		mouse_move()
		keyboard_move()

	#print(in_up,"|",in_down,"|",in_left,"|",in_right)
	#if position != target and target != Vector2(0,0):
		#print("!")
		#lerp(position,target,1)
#
#func focus_on_target(focus_position:Vector2) -> void:
	#target = focus_position
