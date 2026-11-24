@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextNodeEffect
extends RichTextEffect
## эффект для нод

var bbcode := "node_effect"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = "#e77df5"
	return true
