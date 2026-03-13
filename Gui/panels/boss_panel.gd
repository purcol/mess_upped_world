@icon("res://assets/textures/node_icons/boss_panel_icon.png")
class_name BossPanel
extends TabContainer

@export var boss_name:String = ""

func _ready() -> void:
	get_tab_bar().mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
