extends Area2D
class_name HoverButtonArea
## Аналог [HoverArea] для [HoverButton].

var collision_name:String = "Collision"

func _ready() -> void:
	var collision:CollisionShape2D = CollisionShape2D.new()
	
	collision.name = collision_name
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(60,60)
	collision.position = Vector2(30,30)
	add_child(collision)
	
	area_entered.connect(hover)
	area_exited.connect(unhover)

func hover(area:Area2D):
	if area is HoverArea: GU.last_hovered = area.get_node("../").get_path()

func unhover(area:Area2D):
	GU.last_hovered = NodePath("")
