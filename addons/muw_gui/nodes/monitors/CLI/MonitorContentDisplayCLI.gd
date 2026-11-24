@icon("res://addons/muw_gui/textures/icons/MonitorContentDisplayCLI.svg")
@tool
extends MonitorCLI
class_name MonitorContentDisplayCLI
## Отображает информацию о входящей и выходящей информации монитора. 
## Кнопка "отпр" отправляет данные провода "WireOutConnectionPoint"

## Скрипт кнопки отправки
@export var script_res:Script = load("res://addons/muw_gui/nodes/monitors/CLI/buttons_scripts/sendcontent.gd")
## Контент для отправки.
@export var content:Array[Variant] = []

func draw_ui() -> void:
	pre_effects(true)
	
	if !get_node("../").has_node("Wires"): return
	delete_buttons()
	self.create_button("ОтПр",Vector2i(0,0),true,script_res)
	var line:int = 1
	
	draw_text("Вход:",Vector2(line,0));line += 1
	var in_content = get_node("../").get_named_in_content()
	for i in in_content:
		draw_text(i+str(in_content[i]),Vector2(line,0))
		line += 1
	
	draw_text("Вывод:",Vector2(line,0));line += 1
	in_content = get_node("../").get_named_out_content()
	for i in in_content:
		draw_text(i+str(in_content[i]),Vector2(line,0))
		line += 1
	
	post_effects()

func _on_wire_input_changed(input:Array[Variant]):
	draw_ui()
