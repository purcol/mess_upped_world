@tool
@icon("res://assets/textures/node_icons/boss_subpanel_icon.png")
class_name BossSubPanel
extends Panel

##иконка.
@export var icon:Texture2D = preload("uid://cfjqmb3xhcb3e")
@export var title:String = ""
@export var unlock_comment:String = ""
@export_multiline var description:String = ""
@export_enum("NONE","TUTORIAL_BOSS_E","LAZER_TAG_BOSS_E") var Boss = 0
@export_enum("NORMAL","MASTER","NIGHTMARE") var Difficulty = 0


func _process(_delta: float) -> void:
	$VSplit/BossSubPanelButton.Boss = Boss
	$VSplit/BossSubPanelButton.Difficulty = Difficulty
	$VSplit/VSplit/HSplit/Icon.texture = icon
	$VSplit/VSplit/HSplit/Title.text = title
	$VSplit/VSplit/Description.text = ""
	if !Engine.is_editor_hint():
		if !$VSplit/BossSubPanelButton.is_unlocked() && unlock_comment != "": $VSplit/VSplit/Description.text = "[warn]"+unlock_comment+"[/warn]\n"
	else: if unlock_comment != "": $VSplit/VSplit/Description.text = "[warn]"+unlock_comment+"[/warn]\n"
	$VSplit/VSplit/Description.text += description
