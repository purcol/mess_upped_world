@tool
extends RichTextEffect
class_name RichTextWeaponEffect
## эффект для оружия

var bbcode := "weapon_effect"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = "#ffea76"
	return true
