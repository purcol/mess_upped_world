@tool
@icon("res://assets/textures/node_icons/boss_subpanel_button_icon.png")
class_name BossSubPanelButton
extends Button

@export_enum("NONE","TUTORIAL_BOSS_E","LAZER_TAG_BOSS_E") var Boss = 0
@export_enum("NORMAL","MASTER","NIGHTMARE") var Difficulty = 0

#region setup
func _validate_property(property: Dictionary) -> void:
	if property.name == "text" \
	 or property.name == "icon" \
	 or property.name == "toggle_mode" \
	 or property.name == "flat":
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _ready() -> void:
	toggle_mode = true
	if !Engine.is_editor_hint():
		text = "Начать Битву!"
		G.print_log("ButtonInit",["Node "+name+" has been setuped."])
	else:
		text = str(Boss)
#endregion

#region checks
##должно возврашать true если сложность открыта.
func is_unlocked() -> bool: return G.unloked_bosses[Boss][Difficulty]
#endregion

#region frame exec
func _process(_delta: float) -> void:
	in_game_updates()
	if Engine.is_editor_hint(): text = "ID: "+str(Boss)+" Dif: "+str(Difficulty)

##этот метод вызывается каждый _process и имеет эффект только во время игры.
func in_game_updates() -> void:
	if Engine.is_editor_hint(): return
	focus_mode = FocusMode.FOCUS_NONE
	text = "Начать Битву!"
	update_disabled()

##обновляет свойство disabled при этом возвращая его значение.
func update_disabled() -> bool:
	disabled = !is_unlocked()
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if is_unlocked() else Control.CURSOR_FORBIDDEN
	return disabled
#endregion

#region action
func _toggled(_toggled_on: bool) -> void:
	G.selected_boss = Boss
	G.selected_difficulty = Difficulty
	get_tree().change_scene_to_file("res://worlds/battel_zone.tscn")
#endregion
