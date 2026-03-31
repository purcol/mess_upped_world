@tool
class_name WarnEffect
extends RichTextEffect

var bbcode = "warn"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = "#ff7373"
	return true
