@icon("res://addons/muw_gui/textures/icons/WireOutConnectionPoint.svg")
@tool
extends WireConnectionPoint
class_name WireOutConnectionPoint
## Класс ноды для передачи информации. См. [WireInConnectionPoint]

func _ready() -> void:
	super._ready()
	
	# добавление кнопки
	var button:HoverButton = HoverButton.new()
	button.name = button_name
	button.toggle_mode = true
	button.size = Vector2(60,60)
	add_child(button)
	get_node(button_name).aply_points_conection.connect(aply_conection)
	update_point()

func _process(_delta: float) -> void:
	if wire_data == null: wire_data = WireOutResoure.new()
	super._process(_delta)
	if !Engine.is_editor_hint(): queue_redraw()

## Обновлене точки подключения
func update_point() -> void:
	super.update_point()
	
	if !has_node(button_name): return
	var button:HoverButton = get_node(button_name)
	
	if wire_data == null: return
	button.position = get_offset(wire_data,Vector2(30,30)) if !get_node(button_name).is_prew_wire \
	else get_local_mouse_position()

func _draw() -> void:
	if !has_node(button_name): return
	if get_node(button_name).is_prew_wire: draw_line(get_offset(wire_data),get_local_mouse_position(),Color.RED,1)
	if !get_node(button_name).is_prew_wire and wire_data.path_to_receiver != NodePath(""): 
		var resiver:Node2D = get_tree().root.get_node("Root").get_node(wire_data.path_to_receiver).get_node(sprite_name)
		draw_line(get_offset(wire_data),resiver.global_position-global_position,Color.RED,1)

## Соеденяет точки подключения и обновляет их информацию. [param path] - путь к точке.
func aply_conection(path:NodePath) -> void:
	delete_conection(wire_data.path_to_receiver)
	if GU.last_hovered == NodePath(""): return
	if get_tree().root.get_node("Root") == null: return
	var resiver:WireConnectionPoint = get_tree().root.get_node("Root").get_node(path)
	if resiver.get_node("../..") == get_node("../.."): return
	if resiver is WireOutConnectionPoint: return
	if resiver.wire_data.path_to_emitter != NodePath(""): return
	resiver.wire_data.path_to_emitter = get_path()
	wire_data.path_to_receiver = path
	wire_data.conect_signal_to_node(resiver.resive_content)

## Удаляет точки подключения и обновляет их информацию. [param path] - путь к точке.
func delete_conection(path:NodePath) -> void:
	if wire_data.path_to_receiver == NodePath(""): return
	var resiver:WireConnectionPoint = get_tree().root.get_node("Root").get_node(path)
	if resiver.get_node("../..") == get_node("../.."): return
	if resiver is WireOutConnectionPoint: return
	resiver.wire_data.path_to_emitter = NodePath("")
	wire_data.path_to_receiver = NodePath("")
	wire_data.disconect_signal_to_node(resiver.resive_content)

func emmit_content(content:Array[Variant]=[null]) -> void:
	wire_data.content = wire_data.content if content == [null] else content
	if get_node("../../") is MonitorFrame:
		get_node("../../").wire_output_changed.emit(content)
