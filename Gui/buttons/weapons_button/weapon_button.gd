@tool
##кнопка ипользуемая для достижений.
@icon("res://assets/textures/node_icons/weapon_icon.png")
class_name WeaponButton
extends BasicButton

func is_unlocked() -> bool: return Engine.is_editor_hint()
