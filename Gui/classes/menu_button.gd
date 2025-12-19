class_name GameMenuButton
extends Button

@export_category("Button config")
## когда включенно: выключает кнопку если не выбрано ни одного оружия
@export var needs_weapons:bool = false
## когда включенно: принажатии открывает дочернию панель
@export var is_panel_button:bool = false
## когда включенно: заменяет нажатие на наведение
@export var is_hower_button:bool = false
@export var animation_time:float = 0.5

@export_category("Actions")
## есди не `null`, то при нажатии изменяет текущую сценну на указаную 
@export var change_scene:PackedScene

var panel_size
var panel:Panel

func _ready() -> void:
	if is_panel_button and has_node("Panel"): 
		panel = get_node("Panel")
		panel_size = panel.size
		panel.visible = false
		panel.size.y = 3
	else:
		await get_tree().create_timer(0.001).timeout
		if (is_panel_button or is_hower_button) and has_node("Panel"): 
			panel = get_node("Panel")
			panel_size = panel.size
			panel.visible = false
			panel.size.y = 3

func _toggled(toggled_on: bool) -> void:
	if is_panel_button and !is_hower_button:
		toggle_panel(toggled_on,panel_size,animation_time)
	if change_scene:
		G._save()
		get_tree().change_scene_to_file(change_scene.resource_path)
	focus_mode = Control.FOCUS_NONE

func _process(_delta: float) -> void:
	if is_panel_button:
		if panel.has_node("Border"):
			panel.get_node("Border").size = panel.size
	if needs_weapons:
		if G.selected_weapons.size() <= 0:
			disabled = true
		else:
			disabled = false
	
	focus_mode = Control.FOCUS_NONE
	if is_hovered() and !disabled:
		if $Control/SelectionArrow != null:
			$Control/SelectionArrow.visible = true
		if is_hower_button:
			toggle_panel(true,panel_size,animation_time)
	else:
		if $Control/SelectionArrow != null:
			$Control/SelectionArrow.visible = false
		if is_hower_button:
			toggle_panel(false,panel_size,animation_time)


func toggle_panel(toggled_on:bool,open_panel_size:Vector2,anim_time:float=0.5,closed_panel_size:Vector2=Vector2(-1,-1)) -> void:
	if panel == null: return
	if toggled_on: 
		panel.visible = true
		get_tree().create_tween().tween_property(panel,"size", open_panel_size, anim_time)
	else:
		if closed_panel_size == Vector2(-1,-1):
			get_tree().create_tween().tween_property(panel,"size", Vector2(open_panel_size.x, 3), anim_time)
		else:
			get_tree().create_tween().tween_property(panel,"size", closed_panel_size, anim_time)
		await get_tree().create_timer(anim_time).timeout
		panel.visible = false
