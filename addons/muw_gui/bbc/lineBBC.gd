@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextLineBbc
extends RichTextEffect


# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [line_bbc param=2.0]hello[/line_bbc] in text.
var bbcode := "line_bbc"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var param: float = char_fx.env.get("param", 1.0)
	return true
