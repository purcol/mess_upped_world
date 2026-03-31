@tool
@icon("res://assets/textures/node_icons/rich_description_icon.png")
class_name RichDescription
extends RichTextLabel

func _validate_property(property: Dictionary) -> void:
	if property.name == "custom_effects" \
	or property.name == "bbcode_enabled" \
	or property.name == "text":
		property.usage |= PROPERTY_USAGE_READ_ONLY

func _ready() -> void:
	bbcode_enabled = true
	custom_effects = [BossEffect.new(),WeaponsEffect.new(),DifficultyEffect.new(),WarnEffect.new()]
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
