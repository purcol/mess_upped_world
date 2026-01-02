extends Node

@export_category("Debug")
##выключает урон, зум камер 0.5
@export var dev_mode:bool = false

enum EntytiesIDs{
	ENYORTOTALSTATS = 0,
	Player_E = 1,
	TutorialBoss_E = 2,
	Bullet_E = -1
}

enum BossesID{
	NONE = 0,
	TUTORIAL_BOSS_E = 1,
	LAZER_TAG_BOSS_E = 2
}

const BOSSES:Dictionary = {
	1:"res://entity/bosses/tutorial_boss_e.tscn",
	2:"res://entity/bosses/lazer_tag_boss_e.tscn"
}

var selected_boss = BossesID.NONE

var selected_weapons:Array[String] = []
var total_time:float = 0
var died_to:Dictionary = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
var win_to:Dictionary = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}

var opened_buton:NodePath = ""

func _ready() -> void:
	if G.selected_weapons == null: await get_tree().create_timer(0.01).timeout; _load()
	else: _load()#save_game = save_game.load_savefile()
	pass

func _process(delta: float) -> void:
	#print(selected_boss)
	total_time += delta
	if Input.is_action_pressed("quick_exit"): update_and_save(); get_tree().quit()

#region save system
var save_location = "user://save_file.json"

var contents_to_save:Dictionary = {
	"selected_weapons":[],#shoter
	"total_time":0.0,
	"died_to":{"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0},
	"win_to":{"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
}


func _save() -> void:
	var file = FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load() -> int:
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location,FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		print(save_data)
		selected_weapons.assign(save_data.selected_weapons)
		total_time = save_data.total_time
		died_to.assign(save_data.died_to)
		win_to .assign(save_data.win_to)
		return 0
	return 1

func _update_contents_to_save() -> void:
	for weapon in G.selected_weapons: #"res://components/weapons_shoters/"+weapon+"_c.tscn"
		if !FileAccess.file_exists("res://components/weapons_shoters/"+weapon+"_c.tscn"):
			G.selected_weapons.erase(weapon)
			push_warning("Cannot find file(weapon) 'res://components/weapons_shoters/"+weapon+"_c.tscn'.")
	
	G.contents_to_save.selected_weapons = G.selected_weapons
	G.contents_to_save.total_time = G.total_time
	G.contents_to_save.died_to = G.died_to
	G.contents_to_save.win_to = G.win_to

func update_and_save() -> void:
	_update_contents_to_save()
	_save()

func reset_save() -> void:
	selected_weapons.assign([])
	total_time = 0
	died_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}
	win_to = {"total":0,"TutorialBoss_E":0,"LazerTagBoss_E":0}

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_CRASH or what == NOTIFICATION_DISABLED:
		update_and_save()
		get_tree().quit() # default behavior
#endregion

func set_oppen_button(button:NodePath) -> void:
	opened_buton = button
	print(opened_buton)
