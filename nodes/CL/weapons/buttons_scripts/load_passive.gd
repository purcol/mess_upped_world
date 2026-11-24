extends Button

func _pressed() -> void:
	if get_node("./../../").has_node("WeaponsListCLI"):
		get_node("./../../WeaponsListCLI").load_passve_weapons_list()
