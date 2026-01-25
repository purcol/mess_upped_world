extends MobileBoss

func _process(_delta: float) -> void:
	super(_delta)
	if (get_tree().get_first_node_in_group("Player").global_position-global_position).abs().length() <= 96:
		$Components/MiniWaveAttak/WaveShoterMW1.is_on = true
