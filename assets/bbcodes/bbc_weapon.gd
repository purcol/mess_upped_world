@tool
class_name WeaponsEffect
extends RichTextEffect

var bbcode = "weap"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = "#ffea76"
	return true
