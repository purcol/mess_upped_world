@tool
@icon("res://assets/nodes/standart_buttom.png")

class_name StandartButtom
extends Button

func _init() -> void:
	theme = load("res://assets/theme/standart::844ij.tres")
	text = "button"
	var control_inst = load("res://templates/button_template.tscn").instantiate()
	for i in control_inst.get_children():
		add_child(i)

func update_button() -> void:
	focus_mode = Control.FOCUS_NONE
	if is_hovered():
		if get_node("SelectionArrow") != null:
			$SelectionArrow.visible = true
	else:
		if get_node("SelectionArrow") != null:
			$SelectionArrow.visible = false

func toggle_update_button() -> void:
	focus_mode = Control.FOCUS_NONE

func _toggled(_toggled_on: bool) -> void:
	toggle_update_button()

func _process(_delta: float) -> void:
	update_button()
