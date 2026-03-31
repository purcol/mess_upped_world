@tool
@icon("res://assets/textures/node_icons/basic_panel_icon.png")
class_name BasicItemSubpanel
extends Panel

##иконка.
@export var icon:Texture2D = load("uid://cfjqmb3xhcb3e")
##заголовок.
@export var title:String = ""
##описание достижения.
@export_multiline var description:String = ""

var path_icon:String = "./VSplit/HSplit/Icon"
var path_title:String = "./VSplit/HSplit/Title"
var path_desc:String = "./VSplit/Description"

func _process(_delta: float) -> void:
	get_node(path_icon).texture = icon
	get_node(path_title).text = title
	get_node(path_desc).text = description
