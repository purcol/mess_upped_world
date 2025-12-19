extends Camera2D

@export var speed:float = 10


func _process(_delta: float) -> void:
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
		
	#print(in_up,"|",in_down,"|",in_left,"|",in_right)
