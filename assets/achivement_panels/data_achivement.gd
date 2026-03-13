@tool
@icon("res://assets/textures/node_icons/data_achivment_panel.png")
class_name AchievementDataSubPanel
extends AchievementSubPanel

func _process(_delta: float) -> void:
	$VSplit/HSplit/Icon.texture = icon
	if !Engine.is_editor_hint():
		$VSplit/HSplit/Title.text = G.save_location
		$VSplit/Description.text = str(G.get_save())
