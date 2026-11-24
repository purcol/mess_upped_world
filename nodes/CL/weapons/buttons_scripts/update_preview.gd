extends Button

var item

func _pressed() -> void:
	if get_node("./../../").has_node("ItemDescPreview"):
		get_node("./../../ItemDescPreview").item = item
