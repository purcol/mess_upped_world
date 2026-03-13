extends MobileBoss

func update_stage():
	if current_stage >= 2:
		$StormSprite.visible = true
		if current_stage == 2:
			get_tree().create_tween().tween_property($StormSprite,"modulate",Color(1,1,1,1),0.1)
	if current_stage == 3:
		$LazerSprite.modulate = Color(1,1,1,0)
		get_tree().create_tween().tween_property($LazerSprite,"modulate",Color(1,1,1,1),0.1)
		get_tree().create_tween().tween_property($lazerCoverUpSprite,"modulate",Color(1,1,1,0),0.1)
	super()
