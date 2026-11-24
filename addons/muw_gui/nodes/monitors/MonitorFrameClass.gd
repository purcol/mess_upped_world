@tool
@icon("res://addons/muw_gui/textures/icons/MonitorFrame.svg")
extends NinePatchRect
class_name MonitorFrame

## Название ноды с точками подключения.
var wires_node:String = "Wires"

## всё что входит в монитор
var wire_input:Array[Variant] = [] :
	set(val):
		wire_input = val
		wire_input_changed.emit(val)

## всё что из нео выходит
@export var wire_output:Array[Variant] = [] :
	set(val):
		wire_output = val
		wire_output_changed.emit(val)

signal wire_output_changed(output:Array[Variant])
signal wire_input_changed(input:Array[Variant])

func _enter_tree() -> void:
	texture = GU.monitor_texture
	patch_margin_bottom = 40
	patch_margin_top = 40
	patch_margin_right = 110
	patch_margin_left = 110

func _ready() -> void:
	sync_out_content()

func _process(_delta: float) -> void:
	if custom_minimum_size.x < patch_margin_right+patch_margin_left:
		custom_minimum_size.x = patch_margin_right+patch_margin_left
	if custom_minimum_size.y < patch_margin_bottom+patch_margin_top:
		custom_minimum_size.y = patch_margin_bottom+patch_margin_top

## возвращает все content из нод [class WireInConnectionPoint] в [param wires_node], ввиде словоря,
## где ключ это имя ноды. Если монитор не сожержит ноду с именем [param wires_node] этот метод
## возвращет [param GU.EMPTY_CONTENT]
func get_named_in_content() -> Dictionary[String,Array]:
	if !has_node(wires_node): return GU.EMPTY_CONTENT
	var dic:Dictionary[String,Array] = {}
	for node in get_node(wires_node).get_children():
		if node is WireInConnectionPoint:
			dic.set(node.name.replace("WireInConnectionPoint","WCP")+":",node.wire_data.content)
	return dic

## возвращает все content из нод [class WireOutConnectionPoint] в [param wires_node], ввиде словоря,
## где ключ это имя ноды. Если монитор не сожержит ноду с именем [param wires_node] этот метод
## возвращет [param GU.EMPTY_CONTENT]
func get_named_out_content() -> Dictionary[String,Array]:
	if !has_node(wires_node): return GU.EMPTY_CONTENT
	var dic:Dictionary[String,Array] = {}
	for node in get_node(wires_node).get_children():
		if node is WireOutConnectionPoint:
			dic.set(node.name.replace("WireOutConnectionPoint","WCP")+":",node.wire_data.content)
	return dic

#func get_out_content() -> Array[Variant]:
	#if !has_node(wires_node): return []
	#var cont:Array[Variant] = []
	#for node in get_node(wires_node).get_children():
		#if node is WireOutConnectionPoint:
			#cont.append(node.wire_data.content)
	#return cont

func sync_out_content() -> void:
	#wire_output += get_out_content()
	if !has_node(wires_node): return
	for node in get_node(wires_node).get_children(): if node is WireOutConnectionPoint:
			node.wire_data.content = wire_output
	wire_output_changed.emit(wire_output)

## Обновляет все CL монитора
func update_monitor_ui() -> void:
	for node in get_children():
		if node.has_method("draw_ui"): node.draw_ui()

func _get_configuration_warnings() -> PackedStringArray:
	var flag:bool = true
	for node in get_children():
		if node is MonitorCL: flag = false; break
	if flag: return ["Monitor needs 1 MonitorCL to work"]
	return []

func emmit_content(point:WireOutConnectionPoint=null) -> void:
	if point != null: point.emmit_content(wire_output); return
	if has_node(wires_node):
		for node in get_node(wires_node).get_children():
			if node.has_method("emmit_content"): node.emmit_content(wire_output)
