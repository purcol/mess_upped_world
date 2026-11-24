@tool
extends Control
class_name MonitorControl

func _validate_property(property: Dictionary) -> void:
	match property.name:
		"clip_contents": property.usage |= PROPERTY_USAGE_READ_ONLY
		"anchor_right": property.usage |= PROPERTY_USAGE_READ_ONLY
		"anchor_bottom": property.usage |= PROPERTY_USAGE_READ_ONLY

func _ready() -> void:
	clip_contents = true
	set_anchors_preset(Control.PRESET_FULL_RECT)
	#set_anchor_and_offset(SIDE_BOTTOM,1,-$"..".patch_margin_top)
	#set_anchor_and_offset(SIDE_RIGHT,1,-$"..".patch_margin_top)
	#
	#set_anchor_and_offset(SIDE_TOP,0,$"..".patch_margin_top)
	#set_anchor_and_offset(SIDE_LEFT,0,$"..".patch_margin_top)
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH
	#set_deferred("size",Vector2(
		#$"..".size.x-($"..".patch_margin_left+$"..".patch_margin_left),
		#$"..".size.y-($"..".patch_margin_top+$"..".patch_margin_bottom)
		#))
