@icon("res://addons/muw_gui/textures/icons/WireConnectionPoint.svg")
@tool
extends Node2D
class_name WireConnectionPoint
## Нода точки подключения провода. НЕ использовать этот класс!
## использовать только его наследников ([WireInConnectionPoint], [WireOutConnectionPoint])

## Ресурс хранащий информацию о проводе. См. [WireResoure]
@export var wire_data:WireResoure

# имена нод
## Название ноды спрайта
var sprite_name:String = "Sprite"
## Название ноды зоны сопрекосновения
var area_name:String = "Area"
## Название ноды кнопки
var button_name:String = "Button"

func _ready() -> void:
	# добавление спрайта
	var sprite:WireConectonPointSprite = WireConectonPointSprite.new()
	sprite.name = sprite_name
	sprite.z_index = -1
	sprite.scale = Vector2(10,10)
	sprite.texture = GU.wire_in_end_texture if self is WireInConnectionPoint else GU.wire_out_end_texture
	add_child(sprite)
	update_point()

func _process(_delta: float) -> void:
	update_point()
	if wire_data.offset < 0:
		wire_data.offset = 0
	if wire_data.offset > 1 and wire_data.Mode == GU.POS_MODE.PROCENT:
		wire_data.offset = 1

## Обновлене точки подключения
func update_point() -> void:
	if !has_node(sprite_name): return
	var sprite:WireConectonPointSprite = get_node(sprite_name)
	
	if wire_data != null: sprite.position = get_offset(wire_data)
	sprite.rotation_degrees = 90*wire_data.Side

## Получение отступа от центра точки. [param data] - wire_data точки,
## [param bonuse_offset] - доболнительный оффсет для точки.
func get_offset(data:WireResoure,bonuse_offset:Vector2=Vector2.ZERO)->Vector2:
	# половина размера текстуры
	var boundary:float = 30
	match data.Side:
		GU.SIDE.UP:
			return (Vector2(clampf($"../..".size.x-boundary,boundary,data.offset+boundary),-boundary) if data.Mode == GU.POS_MODE.FIXED \
			else Vector2(clampf($"../..".size.x-boundary,boundary,$"../..".size.x*data.offset+boundary),-boundary))-bonuse_offset
		GU.SIDE.DOWN:
			return (Vector2(clampf($"../..".size.x-boundary,boundary+$"../..".size.y,data.offset+boundary),boundary+$"../..".size.y) if data.Mode == GU.POS_MODE.FIXED \
			else Vector2(clampf($"../..".size.x-boundary,boundary,$"../..".size.x*data.offset+boundary),boundary+$"../..".size.y))-bonuse_offset
		GU.SIDE.LEFT:
			return (Vector2(-boundary,clampf($"../..".size.y-boundary,0,data.offset+boundary)) if data.Mode == GU.POS_MODE.FIXED \
			else Vector2(-boundary,clampf($"../..".size.y-boundary,0,$"../..".size.y*data.offset+boundary)))-bonuse_offset
		GU.SIDE.RIGHT:
			return (Vector2(boundary+$"../..".size.x,clampf($"../..".size.y-boundary,0,data.offset+boundary)) if data.Mode == GU.POS_MODE.FIXED \
			else Vector2(boundary+$"../..".size.x,clampf($"../..".size.y-boundary,0,$"../..".size.y*data.offset+boundary)))-bonuse_offset
		_:
			return bonuse_offset


func _get_configuration_warnings() -> PackedStringArray:
	var flag:bool
	for node in get_node("./..").get_children():
		flag = not node is WireConnectionPoint
		if flag: break
	if (not get_node("./..") is Node2D) or flag:
		return ["Point not in Node2D"]
	return []
