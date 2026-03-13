@tool
@icon("res://assets/textures/node_icons/achivment_panel_icon.png")
class_name AchievementSubPanel
extends Panel

##иконка.
@export var icon:Texture2D = load("uid://cfjqmb3xhcb3e")
##заголовок.
@export var title:String = ""
##описание достижения.
@export_multiline var description:String = ""


func _process(_delta: float) -> void:
	$VSplit/HSplit/Icon.texture = icon
	$VSplit/HSplit/Title.text = title
	$VSplit/Description.text = description
