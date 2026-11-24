@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextWarningEffect
extends RichTextEffect
## эффект предупреждений

var bbcode := "warning_effect"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = "#ff7373"
	return true
