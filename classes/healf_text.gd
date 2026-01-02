@tool
class_name HealfText
extends LineEdit

@export var offset:Vector2 = Vector2.ZERO

func _process(_delta: float) -> void:
	text = str($"../Components/Healf_C".healf)
	if get_node("..").is_in_group("Entity"): 
		rotation = -get_node("..").rotation
		global_position = get_node("..").global_position + Vector2(-size.x*scale.x*0.5,0) + offset

func _input(_event: InputEvent) -> void:
	pass
