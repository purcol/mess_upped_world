@tool
class_name GameDescriptionPanel
extends Panel

@export_multiline() var text = ""

func _process(_delta: float) -> void:
	$Description.size = size * $Description.scale
	$Description.text = text
	$Border.size = size
