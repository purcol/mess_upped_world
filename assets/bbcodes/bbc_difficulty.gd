@tool
class_name DifficultyEffect
extends RichTextEffect

var bbcode = "dif"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	match char_fx.env.get("d"):
		"n": char_fx.color = "light_green"
		"m": char_fx.color = "#ff7373"
		"N": char_fx.color = "dark_magenta"
		_: char_fx.color = "dim_gray"
	return true
