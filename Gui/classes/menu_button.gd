@tool
class_name GameMenuButton
extends Button

@export_category("Button config")
## когда включенно: выключает кнопку если не выбрано ни одного оружия
@export var needs_weapons:bool = false
## когда включенно: принажатии открывает дочернию панель
@export var is_panel_button:bool = false
## когда включенно: заменяет нажатие на наведение
@export var is_hower_button:bool = false
@export var calc_panel_size:bool = false
@export var animation_time:float = 0.5

@export_category("Actions")
## если не `null`, то при нажатии изменяет текущую сценну на указаную 
@export var change_scene:PackedScene
@export_enum("NONE","EXIT_ANIM","SOUNDS") var flip_setting = 0
@export var settings_list:Dictionary[int,String] = {0:"none",1:"exit_animation",2:"sounds"}

@export_category("Other")
## если `true` наводит камеру на себя при нажатии
@export var forus_camera:bool = false
## офсен наводки
@export var forus_camera_offset:Vector2 = Vector2.ZERO

var panel_size = Vector2(0,0)
@onready var close_size = panel_size
var panel:Panel
@onready var ready_disable = disabled
#var nested_button_oppend = null

func panel_setup() -> void:
	#region scary, unknow even to writer, stuff
	if is_panel_button and has_node("Panel") and !Engine.is_editor_hint(): 
		G.print_log("ButtonInit",["Panel setup of ", name, " started."])
		panel = get_node("Panel")
		if calc_panel_size:
			var panel_last_child = panel.get_child(panel.get_child_count()-1)
			var plc_size = panel_last_child.size*panel_last_child.scale
			var last_cild_of_child = panel_last_child.get_child(clamp(panel_last_child.get_child_count()-1,0,INF))
			var lcoc_size = last_cild_of_child.get_child(1).size
			#print(lcoc_size)
			panel.size.x = lcoc_size.x+panel_last_child.size.x
			panel.size.y = (plc_size.y/3*(panel_last_child.get_child_count()))+lcoc_size.y
			close_size.x = lcoc_size.x+panel_last_child.size.x
			close_size.y = (plc_size.y/3*(panel_last_child.get_child_count()))
			#print(close_size)
		else: close_size = panel.size
		#for child in get_node("Panel").get_child(get_node("Panel").get_child_count()-1):
		panel_size = panel.size
		panel.visible = false
		panel.size.y = 3
	else:
		if !Engine.is_editor_hint():
			G.print_log("ButtonInit",["Panel setup of ", name, " started."])
			await get_tree().create_timer(0.001).timeout
			if (is_panel_button or is_hower_button) and has_node("Panel"): 
				panel = get_node("Panel")
				if calc_panel_size:
					var panel_last_child = panel.get_child(panel.get_child_count()-1)
					var plc_size = panel_last_child.size*panel_last_child.scale
					var last_cild_of_child = panel_last_child.get_child(clamp(panel_last_child.get_child_count()-1,0,INF))
					var lcoc_size = last_cild_of_child.get_child(1).size
					#print(lcoc_size)
					panel.size.x = lcoc_size.x+panel_last_child.size.x
					panel.size.y = (plc_size.y*(panel.get_child_count()-1))+lcoc_size.y
					close_size.x = lcoc_size.x+panel_last_child.size.x
					close_size.y = plc_size.y*(panel.get_child_count()-1)
				else: close_size = panel.size
				panel_size = panel.size
				panel.visible = false
				panel.size.y = 3
	#if calc_panel_size:
		#print(close_size)
	#endregion

func _ready() -> void:
	panel_setup()

func _toggled(toggled_on: bool) -> void:
	#region close oher buttons
	if !Engine.is_editor_hint():
		G.print_log("ButtonInit",[name, " toggeled."])
		if G.opened_buton != NodePath("") and toggled_on:
			if G.opened_buton != self.get_path() and G.opened_buton != owner.get_path():
				get_tree().root.get_node(G.opened_buton)._toggled(false)
				get_tree().root.get_node(G.opened_buton).button_pressed = false
		if toggled_on and G.opened_buton != owner.get_path():
			G.set_oppen_button(self.get_path())
	#endregion
	if forus_camera:
		var global_scale = get_global_transform().get_scale()
		G.print_log("ButtonInit",[name, " focused camera on ",self.global_position+((self.size*global_scale)*0.5)+forus_camera_offset,"."])
		get_tree().create_tween().tween_property(get_tree().get_first_node_in_group("World").get_node("Camera2D"), "position", self.global_position+((self.size*global_scale)*0.5)+forus_camera_offset, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	if is_panel_button and !is_hower_button and !Engine.is_editor_hint():
		toggle_panel(toggled_on,panel_size,animation_time)
	#region Action
	if change_scene and !Engine.is_editor_hint():
		change_scene_action(change_scene)
	
	if flip_setting != 0:
		match flip_setting:
			1: flip_setting_action("exit_animation")
			2:flip_setting_action("sounds")
	#endregion
	focus_mode = Control.FOCUS_NONE

#region Action functions
func change_scene_action(to_what:PackedScene,save:bool=true) -> void:
	G.print_log("ButtonInit",["Changing scene to ",change_scene,"..."])
	$Control/SelectionArrow.can_fliker = false
	process_mode = Node.PROCESS_MODE_DISABLED
	if save: G.update_and_save()
	var camera = get_tree().get_first_node_in_group("Camera")
	get_tree().create_tween().tween_property(camera,"position",Vector2(camera.position.x,camera.position.y+2000),1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(to_what.resource_path)

##переключает настроку с именем `setting`. Если настройка разна null или не является bool выбрасывает ошибку.
func flip_setting_action(setting:String) -> void:
	G.print_log("ButtonInit",[name, "fliped setting \"",setting,"\"."])
	if G.settings[setting] == null: push_error("ERROR!| setting \"", setting,"\" is null!"); return
	if !(G.settings[setting] is bool): push_error("ERROR!| setting \"", setting,"\" is not type of bool!"); return
	if G.settings[setting]: G.settings[setting] = false
	else:                   G.settings[setting] = true
	#if G.get(setting) == null: push_error("ERROR!| setting \"", setting,"\" is null!"); return
	#if G.get(setting): G.set(setting, false)
	#else:              G.set(setting, true)
#endregion

func disable_check() -> bool:
	#print_debug("disable_check")
	if ready_disable: return true
	if !Engine.is_editor_hint():
		if needs_weapons:
			if G.selected_weapons.size() <= 0:
				return true
	return false

func set_cursor_shape() -> void:
	if disabled:
		mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _process(_delta: float) -> void:
	set_cursor_shape()
	if !Engine.is_editor_hint():
		#region panel button stuff
		if is_panel_button:
			#print(panel, name)
			if panel == null: panel_setup()
			if panel.has_node("Border"):
				panel.get_node("Border").size = panel.size
		disabled = disable_check()
		#endregion
		focus_mode = Control.FOCUS_NONE
		#region hover button process 
		if is_hovered() and !disabled:
			if $Control/SelectionArrow != null:
				if $Control/SelectionArrow.filker != null: $Control/SelectionArrow.filker = true
				$Control/SelectionArrow.visible = true
			if is_hower_button and !Engine.is_editor_hint():
				#print_debug("_process is_hower_button !editor_hint !disabled")
				toggle_panel(true,panel_size,animation_time)
		else:
			if $Control/SelectionArrow != null:
				#print("!!!",name)
				if $Control/SelectionArrow.filker != null: $Control/SelectionArrow.filker = false
				$Control/SelectionArrow.visible = false
			if is_hower_button and !Engine.is_editor_hint():
				#print_debug("_process is_hower_button !editor_hint")
				toggle_panel(false,panel_size,animation_time)
		#endregion
	queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		if forus_camera:
			draw_dashed_line((self.size*0.5),(self.size*0.5)+forus_camera_offset,Color.CORAL,0.5)
			draw_circle((self.size*0.5)+forus_camera_offset,1,Color.ORANGE)

func toggle_panel(toggled_on:bool,open_panel_size:Vector2,anim_time:float=0.5,closed_panel_size:Vector2=Vector2(-1,-1)) -> void:
	if panel == null: return
	if Engine.is_editor_hint(): return
	if toggled_on and !Engine.is_editor_hint(): 
		if !is_hower_button: G.print_log("ButtonInit",[name, " oppening panel."])
		panel.visible = true
		get_tree().create_tween().tween_property(panel,"size", open_panel_size, anim_time)
	else:
		if !Engine.is_editor_hint():
			if !is_hower_button: G.print_log("ButtonInit",[name, " closing panel."])
			if closed_panel_size == Vector2(-1,-1) and !Engine.is_editor_hint():
				panel.size = close_size
				get_tree().create_tween().tween_property(panel,"size", Vector2(open_panel_size.x, 3), anim_time)
			else:
				if !Engine.is_editor_hint():
					panel.size = close_size
					#get_tree().create_tween().tween_property(panel,"size", close_size, 0.01)
					#await get_tree().create_timer(anim_time).timeout
					get_tree().create_tween().tween_property(panel,"size", closed_panel_size, anim_time)
			await get_tree().create_timer(anim_time).timeout
			panel.visible = false
