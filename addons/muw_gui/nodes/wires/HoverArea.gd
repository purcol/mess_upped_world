@icon("res://addons/muw_gui/textures/icons/HoverArea.svg")
extends Area2D
class_name HoverArea
## Зона которая, при входе курсора в её облоость, задаёт [param GlobalGUIScript.last_hovered]  

##
var collision_name:String = "Collision"

func _ready() -> void:
	# добавление коизии
	var collision:CollisionShape2D = CollisionShape2D.new()
	
	collision.name = collision_name
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(60,60)
	add_child(collision)
	
	mouse_shape_entered.connect(hover)

## Подключается к [signal mouse_shape_entered]. Задаёт [param GlobalGUIScript.last_hovered].
func hover(shape_idx:int)->void:
	GU.last_hovered = $"../".get_path()
	#print(GU.last_hovered)
