extends Node

#region cursors textures
const AIM_CURSOR = preload("uid://1eydemn3da4k")
const CURSOR_POINT_HAND = preload("uid://lg2m68d56o1c")
const CURSOR_ARROW = preload("uid://c8j13gbv668ey")
const CURSOR_CROSS = preload("uid://bwu8dqrihi1os")
#endregion

@export_category("Debug")
##выключает урон, зум камер 0.5.
@export var dev_mode:bool = false
##словарь содержащий настройки логирования.
## StartupInit - иницализация при запуске игры и сцен вообщем.
## SaveAndLoad - сохранения и загрузки.
## ButtonInit - иницализация/действия/логика кнопок.
## PlayerInit - иницализация игрока.
## EntityInteractions - взаимодействие/дайствия сущностей.
## EntityFrequentInteractions - частые EntityInteractions, по типу смерти пули. 
## WorldActions - процессы мира.
@warning_ignore("shadowed_global_identifier")
@export var log:Dictionary[String,bool] = {
	"StartupInit":false,
	"SaveAndLoad":false,
	"ButtonInit":false,
	"PlayerInit":false,
	"EntityInteractions":false,
	"EntityFrequentInteractions":false,
	"WorldActions":false
	}
@export var hide_backround:Dictionary[String,bool] = {"Pease":false,"BattelZone":false}

#region entityes var
##следует удалить... ID некоторых сущностей в игре.
enum EntytiesIDs{
	ENYORTOTALSTATS = 0,
	Player_E = 1,
	TutorialBoss_E = 2,
	Bullet_E = -1
}

##ID боссов. 0 - босс отсутствует или не выбран.
enum BossesID{
	NONE = 0,
	TUTORIAL_BOSS_E = 1,
	LAZER_TAG_BOSS_E = 2
}

##пути к босам по их BossesID.
const BOSSES:Dictionary = {
	1:"res://entity/bosses/tutorial_boss_e.tscn",
	2:"res://entity/bosses/lazer_tag_boss_e.tscn"
}

##выбранный босс.
var selected_boss = BossesID.NONE
#endregion

#region stats var
##ограниченный 1 пассивным и 1 активным оружием список выбранных орудий.
var selected_restricted_weapons:Dictionary[String,String] = {
	"active":"",
	"passive":""}
##список выбранных оружий.
var selected_weapons:Array[String] = []
##выбранный вид двежения. Числа брать из MovementType игрока.
var selected_movement:int = 0
##общее время в игре.
var total_time:float = 0
##список смертей.
var died_to:Dictionary = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
##список побед.
var win_to:Dictionary = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
##словарь хранящий настройки.
var settings:Dictionary = {"exit_animation":true,
							"exit_animation_speed":1.0,
							"sounds":true}
##последняя нажатая(следовательно и окрытая) кнопка.
var opened_buton:NodePath = ""
#endregion

#region var manegment
func earese_from_restricted(value:String) -> String:
	var key = selected_restricted_weapons.find_key(value)
	if key == null: push_error("Can't earese from null key!"); return ""
	if selected_restricted_weapons[key] != "":
		selected_restricted_weapons[key] = ""
	if selected_weapons.has(value): selected_weapons.erase(value)
	else: push_error("selected_weapons dose not have "+value+" to earese!")
	G.print_log("ButtonInit",[value+" was earesed from restricted weapons with key: "+key])
	#print("INFO| "+value+" was earesed from restricted weapons with key: "+key)
	return key

func set_oppen_button(button:NodePath) -> void:
	opened_buton = button
	print(opened_buton)
#endregion

#region init
func _ready() -> void:
	set_cursor_textures()
	if G.selected_weapons == null: await get_tree().create_timer(0.01).timeout; _load()
	else: _load()#save_game = save_game.load_savefile()
	#reset_save("settings")
	pass

func set_cursor_textures() -> void:
	Input.set_custom_mouse_cursor(CURSOR_POINT_HAND,Input.CURSOR_POINTING_HAND,Vector2(15.5,4))
	Input.set_custom_mouse_cursor(CURSOR_CROSS,Input.CURSOR_FORBIDDEN,Vector2(15.5,4))
	G.print_log("StartupInit",["Cursor textures have been set."])
#endregion

#region logs
func print_log(log_type:String,string:Array):
	if log.get(log_type):
		var print_line:String = ""
		var time = Time.get_time_dict_from_system()
		var log_time = str(time.get("hour"))+"."+str(time.get("minute"))+"."+str(time.get("second"))
		for i in string:
			print_line = print_line+str(i)
		match log_type:
			"StartupInit": print_line = "[SI]| " + print_line
			"SaveAndLoad": print_line = "[SL]| " + print_line
			"ButtonInit": print_line = "[BI]| " + print_line
			"PlayerInit": print_line = "[PI]| " + print_line
			"EntityInteractions": print_line = "[EI]| " + print_line
			"EntityFrequentInteractions": print_line = "[Ei]| " + print_line
			"WorldActions": print_line = "[WA]| " + print_line
			_: print_line = "[  ]| " + print_line
		print("INFO|",log_time,"|",print_line)
#endregion

#region save system
##путь сохранения относительно папки игры.
var save_location = "user://save_file.json"

##словарь с состоянием игры (обновлять надо в ручную), который используется при сохранении.  
var contents_to_save:Dictionary = {
	"selected_restricted_weapons":{"active":"","passive":""},
	"selected_weapons":[],#shoter
	"selected_movement":0,
	"total_time":0.0,
	"died_to":{"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0},
	"win_to":{"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0},
	"settings":{"exit_animation":true,"exit_animation_speed":1.0,"sounds":true}
}

func _save() -> void:
	G.print_log("SaveAndLoad",["Save started."])
	var file = FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	G.print_log("SaveAndLoad",["Save completed."])

func _load() -> int:
	G.print_log("SaveAndLoad",["Loading started."])
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location,FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		G.print_log("SaveAndLoad",[save_data])
		if save_data.selected_restricted_weapons != null:
			selected_restricted_weapons.assign(save_data.selected_restricted_weapons)
		if save_data.selected_weapons != null:
			selected_weapons.assign(save_data.selected_weapons)
		else: selected_weapons = []; push_warning("WARNING!| can not load \"selected_weapons\". Loading defalt...")
		if get_tree().get_first_node_in_group("") != null:
			get_tree().get_first_node_in_group("").MovementType = selected_movement
		if save_data.total_time != null:
			total_time = save_data.total_time
		else: total_time = 0; push_warning("WARNING!| can not load \"total_time\". Loading defalt...")
		if save_data.died_to != null:
			died_to.assign(save_data.died_to)
		else: died_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}; push_warning("WARNING!| can not load \"died_to\". Loading defalt...")
		if save_data.win_to != null:
			win_to.assign(save_data.win_to)
		else: win_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}; push_warning("WARNING!| can not load \"win_to\". Loading defalt...")
		if save_data.settings != null:
			settings.assign(save_data.settings)
		else: settings = {"exit_animation":true,"exit_animation_speed":1.0,"sounds":true}; push_warning("WARNING!| can not load \"settings\". Loading defalt...")
		G.print_log("SaveAndLoad",["Loading completed."])
		return 0
	push_error("ERROR| save file doesn't exist!")
	G.print_log("SaveAndLoad",["Loading canceled."])
	return 1

func _update_contents_to_save() -> void:
	G.print_log("SaveAndLoad",["Updating contents to save."])
	G.contents_to_save.selected_restricted_weapons = G.selected_restricted_weapons
	G.contents_to_save.selected_weapons = G.selected_weapons
	G.contents_to_save.selected_movement = G.selected_movement
	G.contents_to_save.total_time = G.total_time
	G.contents_to_save.died_to = G.died_to
	G.contents_to_save.win_to = G.win_to
	G.contents_to_save.settings = G.settings
	G.print_log("SaveAndLoad",["Contents to save has been updated."])

func update_and_save() -> void:
	G.print_log("SaveAndLoad",["Safe save begin."])
	_update_contents_to_save()
	_save()

func reset_save(what:String="*") -> void:
	G.print_log("SaveAndLoad",["Save reset started with argument: ",what,"."])
	if what == "*":
		selected_restricted_weapons.assign({"active":"","passive":""})
		selected_weapons.assign([])
		selected_movement = 0
		total_time = 0
		died_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
		win_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
		settings = {"exit_animation":true,"exit_animation_speed":1.0,"sounds":true}
	if what == "selected_weapons":
		selected_weapons = []
	if what == "selected_movement":
		selected_movement = 0
	if what == "total_time":
		total_time = 0
	if what == "died_to":
		died_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
	if what == "win_to":
		win_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
	if what == "settings":
		settings = {"exit_animation":true,"exit_animation_speed":1.0,"sounds":true}
	G.print_log("SaveAndLoad",["Save reset with argument: ",what," done."])

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_CRASH or what == NOTIFICATION_DISABLED:
		G.print_log("SaveAndLoad",["Uninspected save started."])
		update_and_save()
		get_tree().quit() # default behavior
#endregion

func _process(delta: float) -> void:
	#print(selected_boss)
	total_time += delta
	if Input.is_action_pressed("quick_exit"): update_and_save(); get_tree().quit()
	#если нет активного оружия, то убрать пасивное
	if selected_restricted_weapons["active"] == "":
		selected_restricted_weapons["passive"] = ""
	for i in selected_weapons:
		if selected_restricted_weapons.find_key(i) == null:
			selected_weapons.erase(i)
			print("INFO| "+i+"was erased from selected_weapons")
