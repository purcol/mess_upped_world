extends Button

func _pressed() -> void:
	if has_node("../../"): if get_node("../../").has_method("emmit_content"): get_node("../../").emmit_content()
