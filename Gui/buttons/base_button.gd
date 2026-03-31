@tool
##кнопка ипользуемая для достижений.
@icon("res://assets/textures/node_icons/basic_button_icon.png")
class_name BasicButton
extends Button

##панель достижение.
@export var achievement:PackedScene = load("uid://ghowmfon24cd")
##размар кнопки. Стороны кнопки всегда равны.
@export var self_size:float = 64.0

#region setup
##возврашает ноду панели.
func setup_panel_node() -> BasicItemSubpanel:
	var subpanel:BasicItemSubpanel = achievement.instantiate()
	$Icon.texture = subpanel.icon
	subpanel.visible = false
	return subpanel

func _validate_property(property: Dictionary) -> void:
	if property.name == "text" or property.name == "icon" or property.name == "toggle_mode":
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _ready() -> void:
	if button_group == null: button_group = load("res://Gui/buttons/groups/achievements.tres")
	self.add_child(setup_panel_node())
	update_panel()
	toggle_mode = true
	if !Engine.is_editor_hint():
		GDebug.print_log("ButtonInit",["Node "+name+" has been setuped."])
#endregion

#region checks
##возвращает true если нода имеет панель, иначе false.
func has_panel() -> bool:
	return self.has_node("Panel")

##возращает true если на нодау или любой её ребёнка наведён курсор, иначе false.
func is_element_hovered() -> bool:
	if is_hovered(): return true
	for node in get_children(true):
		if node.has_method("is_hovered"):
			if node.is_hovered():
				return true
	return false

##должно возврашать true если достижение открыто.
func is_unlocked() -> bool: return Engine.is_editor_hint()
#endregion

#region frame exec
func _process(_delta: float) -> void:
	size = Vector2(self_size,self_size)
	custom_minimum_size = Vector2(self_size,self_size)
	in_game_updates()

##этот метод вызывается каждый _process и имеет эффект только во время игры.
func in_game_updates() -> void:
	if Engine.is_editor_hint(): return
	focus_mode = FocusMode.FOCUS_NONE
	update_disabled()
	update_panel()

##обновляет свойство disabled при этом возвращая его значение.
func update_disabled() -> bool:
	disabled = !is_unlocked()
	$Icon.modulate = Color.WHITE if is_unlocked() else Color.DARK_GRAY
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if is_unlocked() else Control.CURSOR_FORBIDDEN
	return disabled

##обновление сосстояния понели
func update_panel() -> void:
	if !has_panel(): pass
	$Panel.visible = button_pressed
#endregion
