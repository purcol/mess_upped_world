@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextDifficulty
extends RichTextEffect
## эффект для сложностей

var bbcode := "difficulty_effect"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var param: float = char_fx.env.get("dif", 1.0)
	match param:
		0: char_fx.color = "light_green"
		1: char_fx.color = "#ff7373"
		2: char_fx.color = "dark_magenta"
		3: char_fx.color = "dim_gray"
		_:
			char_fx.color = "#ff0000"
	return true
