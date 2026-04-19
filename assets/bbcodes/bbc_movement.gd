@tool
class_name MovementEffect
extends RichTextEffect

var bbcode = "mov"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = "#93ede7"
	return true
