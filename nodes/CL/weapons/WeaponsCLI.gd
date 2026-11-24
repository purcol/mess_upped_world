@tool
extends MonitorCLI
class_name WeaponsCLI
## Этот CLI показывает все ресурсы оружий, позволяет из выбирать и добавляет выбранные в вывод.



func _ready() -> void:
	super._ready()
	is_scrollable = false

func generic_draw_ui() -> void:
	draw_hor_line(3)
	draw_border()
	draw_text("Вид Оружия:",Vector2(0,1))
	create_button("Активные",Vector2(1,"ПасВид Оружия:".length()+3),-1,load("res://nodes/CL/weapons/buttons_scripts/load_active.gd"))
	create_button("Пасивные",Vector2(1,line_size.x-"Пасивные".length()-7),-1,load("res://nodes/CL/weapons/buttons_scripts/load_passive.gd"))

func draw_ui() -> void:
	super.draw_ui()
	if !Engine.is_editor_hint():
		generic_draw_ui()

func editor_draw_ui() -> void:
	super.editor_draw_ui()
	generic_draw_ui()

func _on_wire_input_changed(_input:Array[Variant]):
	pass
