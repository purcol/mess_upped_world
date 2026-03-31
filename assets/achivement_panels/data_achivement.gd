@tool
@icon("res://assets/textures/node_icons/data_achivment_panel.png")
class_name AchievementDataSubPanel
extends AchievementSubPanel

func _process(_delta: float) -> void:
	$VSplit/HSplit/Icon.texture = icon
	if !Engine.is_editor_hint():
		$VSplit/HSplit/Title.text = GSaves.save_location
		$VSplit/Description.text = set_desc()
		
func set_desc():
	var text_ = ""
	for i in GSaves.get_save():
			text_ += str(i)
			if i is float: text_ += "\n"
	return text_
