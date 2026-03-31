@tool
class_name BossEffect
extends RichTextEffect

var bbcode = "boss"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = "#ff7373"
	return true
