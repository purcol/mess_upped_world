extends Node2D

@onready var active_color:Color = $Camera2D/UpArrow.color
@onready var unactive_color:Color = $Camera2D/DownArrow.color

func _ready() -> void:
	if G.hide_backround.get("Pease"):
		$Beackroung.visible = false
	Input.set_custom_mouse_cursor(G.CURSOR_ARROW,Input.CURSOR_ARROW)
