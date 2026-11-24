@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextMovementEffect
extends RichTextEffect
## эффект для видов движения

var bbcode := "movement_effect"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = "#93ede7"
	return true
