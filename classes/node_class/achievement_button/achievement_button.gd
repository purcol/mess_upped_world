@tool
@icon("res://assets/nodes/achivment_buttom.png")

class_name AchievementButton
extends GameMenuButton

@export var achievement_icon:Texture2D
@export var title:String = ""
@export var description:String = ""

func _init() -> void:
	theme = load("res://assets/theme/standart.tres")
	var panel_inst = load("res://templates/achiement_panel.tscn").instantiate()
	var template_inst = load("res://templates/button_template.tscn").instantiate()
	var control_inst = template_inst.get_node("Control")
	print(control_inst)
	control_inst.reparent(self)
	panel_inst.icon = achievement_icon
	panel_inst._title = title
	panel_inst.description = description
	
	add_child(panel_inst)
	is_panel_button = true
