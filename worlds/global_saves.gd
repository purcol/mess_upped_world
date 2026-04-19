extends Node

#region stats var
##общее время в игре.
var total_time:float = 0
##сколько звёзд игрок поймал
var star_count:float = 0
##список смертей.
var died_to:Dictionary = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
##список побед.
var win_to:Dictionary = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
##словарь хранящий настройки.
var settings:Dictionary = {"exit_animation":true,
							"exit_animation_speed":1.0,
							"sounds":true}
##словарь с состояние разблокировки сложностей боссов
##0 - NORMAL, 1 - MASTER, 2 - NIGHTMARE
var unloked_bosses:Dictionary = {GEntyties.BossesID.NONE:{0:false,1:false,2:false},
								 GEntyties.BossesID.TUTORIAL_BOSS_E:{0:true,1:false,2:false},
								 GEntyties.BossesID.LAZER_TAG_BOSS_E:{0:false,1:false,2:false}
								 }
##последняя нажатая(следовательно и окрытая) кнопка.
var opened_buton:NodePath = ""
#endregion

#region init
func _ready() -> void:
	if GWeapons.selected_weapons == null: await get_tree().create_timer(0.01).timeout; _load()
	else: _load()
	pass
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
	"star_count":0.0,
	"died_to":{"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0},
	"win_to":{"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0},
	"settings":{"exit_animation":true,"exit_animation_speed":1.0,"sounds":true}
}

func _save() -> void:
	GDebug.print_log("SaveAndLoad",["Save started."])
	var file = FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	GDebug.print_log("SaveAndLoad",["Save completed."])

func _load() -> int:
	GDebug.print_log("SaveAndLoad",["Loading started."])
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location,FileAccess.READ)
		var data = file.get_var()
		var sel_weapons = GWeapons.selected_weapons
		file.close()
		
		var save_data = data.duplicate()
		GDebug.print_log("SaveAndLoad",[save_data])
		if save_data.selected_restricted_weapons != null:
			GWeapons.selected_restricted_weapons.assign(save_data.selected_restricted_weapons)
		if save_data.selected_weapons != null:
			sel_weapons.assign(save_data.selected_weapons)
		else: sel_weapons = []; push_warning("WARNING!| can not load \"selected_weapons\". Loading defalt...")
		if get_tree().get_first_node_in_group("") != null:
			get_tree().get_first_node_in_group("").MovementType = GWeapons.selected_movement
		if save_data.total_time != null:
			total_time = save_data.total_time
		else: total_time = 0; push_warning("WARNING!| can not load \"total_time\". Loading defalt...")
		if save_data.star_count != null:
			star_count = save_data.star_count
		else: star_count = 0; push_warning("WARNING!| can not load \"star_count\". Loading defalt...")
		if save_data.died_to != null:
			died_to.assign(save_data.died_to)
		else: died_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}; push_warning("WARNING!| can not load \"died_to\". Loading defalt...")
		if save_data.win_to != null:
			win_to.assign(save_data.win_to)
		else: win_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}; push_warning("WARNING!| can not load \"win_to\". Loading defalt...")
		if save_data.settings != null:
			settings.assign(save_data.settings)
		else: settings = {"exit_animation":true,"exit_animation_speed":1.0,"sounds":true}; push_warning("WARNING!| can not load \"settings\". Loading defalt...")
		GDebug.print_log("SaveAndLoad",["Loading completed."])
		return 0
	push_error("ERROR| save file doesn't exist!")
	GDebug.print_log("SaveAndLoad",["Loading canceled."])
	return 1

func _update_contents_to_save() -> void:
	GDebug.print_log("SaveAndLoad",["Updating contents to save."])
	GSaves.contents_to_save.selected_restricted_weapons = GWeapons.selected_restricted_weapons
	GSaves.contents_to_save.selected_weapons = GWeapons.selected_weapons
	GSaves.contents_to_save.selected_movement = GWeapons.selected_movement
	GSaves.contents_to_save.total_time = GSaves.total_time
	GSaves.contents_to_save.star_count = GSaves.star_count
	GSaves.contents_to_save.died_to = GSaves.died_to
	GSaves.contents_to_save.win_to = GSaves.win_to
	GSaves.contents_to_save.settings = GSaves.settings
	GDebug.print_log("SaveAndLoad",["Contents to save has been updated."])

func update_and_save() -> void:
	GDebug.print_log("SaveAndLoad",["Safe save begin."])
	_update_contents_to_save()
	_save()

func reset_save(what:String="*") -> void:
	GDebug.print_log("SaveAndLoad",["Save reset started with argument: ",what,"."])
	if what == "*":
		GWeapons.selected_restricted_weapons.assign({"active":"","passive":""})
		GWeapons.selected_weapons.assign([])
		GWeapons.selected_movement = 0
		total_time = 0
		died_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
		win_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
		settings = {"exit_animation":true,"exit_animation_speed":1.0,"sounds":true}
	if what == "selected_weapons":
		GWeapons.selected_weapons = []
	if what == "selected_movement":
		GWeapons.selected_movement = 0
	if what == "total_time":
		total_time = 0
	if what == "star_count":
		star_count = 0
	if what == "died_to":
		died_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
	if what == "win_to":
		win_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
	if what == "settings":
		settings = {"exit_animation":true,"exit_animation_speed":1.0,"sounds":true}
	GDebug.print_log("SaveAndLoad",["Save reset with argument: ",what," done."])

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_CRASH or what == NOTIFICATION_DISABLED:
		GDebug.print_log("SaveAndLoad",["Uninspected save started."])
		update_and_save()
		get_tree().quit() # default behavior

func get_save(save_file:bool=false) -> Array:
	if Engine.is_editor_hint(): return []
	var save:Array
	if save_file:
		if FileAccess.file_exists(save_location):
			var file = FileAccess.open(save_location,FileAccess.READ)
			var data = file.get_var()
			file.close()
			var save_data = data.duplicate()
			
			save.append(save_data.selected_weapons)
			save.append(save_data.selected_movement)
			save.append(save_data.total_time)
			save.append(save_data.star_count)
			save.append(save_data.died_to)
			save.append(save_data.win_to)
		return save
	save.append(GWeapons.selected_weapons)
	save.append(GWeapons.selected_movement)
	save.append(total_time)
	save.append(star_count)
	save.append(died_to)
	save.append(win_to)
	return save
#endregion

func _process(delta: float) -> void:
	total_time += delta
	if Input.is_action_pressed("quick_exit"): update_and_save(); get_tree().quit()
