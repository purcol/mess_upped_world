@icon("res://addons/muw_gui/textures/icons/WireInConnectionPoint.svg")
@tool
extends WireConnectionPoint
class_name WireInConnectionPoint
## Класс ноды для получения информации. См. [WireOutConnectionPoint]

func _ready() -> void:
	super._ready()
	
	# добавление зоны наведения
	var area:HoverArea = HoverArea.new()
	area.z_index = 98; 
	area.name = area_name
	add_child(area)
	update_point()

func _process(_delta: float) -> void:
	super._process(_delta)
	if wire_data == null: wire_data = WireInResoure.new()

## Обновлене точки подключения
func update_point() -> void:
	super.update_point()
	
	if !has_node(area_name): return
	var area:HoverArea = get_node(area_name)
	
	if wire_data != null: area.position = get_offset(wire_data)

## функция подключается к раздающей точке, а конкретно к content_emited в wire_data.
func resive_content(content:Array[Variant]):
	wire_data.content = content
	if get_node("../../") is MonitorFrame: 
		get_node("../../").update_monitor_ui()
		get_node("../../").wire_input_changed.emit(content)
	#print(content)
