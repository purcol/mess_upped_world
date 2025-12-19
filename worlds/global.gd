extends Node

enum EntytiesIDs{
	ENYORTOTALSTATS = 0,
	Player_E = 1,
	TuturialBoss_E = 2,
	Bullet_E = -1
}

var selected_weapons:Array[String] = []
var total_time:float = 0
var died_to:Dictionary = {"total":0,"TuturialBoss_E":0}
var win_to:Dictionary = {"total":0,"TuturialBoss_E":0}

func _ready() -> void:
	if G.selected_weapons == null: await get_tree().create_timer(0.01).timeout; _load()
	else: _load()#save_game = save_game.load_savefile()

func _process(delta: float) -> void:
	total_time += delta

#region save system
var save_location = "user://save_file.json"

var contents_to_save:Dictionary = {
	"selected_weapons":[""],#shoter
	"total_time":0.0,
	"died_to":{"total":0,"TuturialBoss_E":0},
	"win_to":{"total":0,"TuturialBoss_E":0}
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
		G.selected_weapons = save_data.selected_weapons
		G.total_time = save_data.total_time
		G.died_to = save_data.died_to
		G.win_to = save_data.win_to
		return 0
	return 1

func _update_contents_to_save() -> void:
	G.contents_to_save.selected_weapons = G.selected_weapons
	G.contents_to_save.total_time = G.total_time
	G.contents_to_save.died_to = G.died_to
	G.contents_to_save.win_to = G.win_to

func update_and_save() -> void:
	_update_contents_to_save()
	_save()

func reset_save() -> void:
	G.selected_weapons = []
	G.total_time = 0
	G.died_to = {"total":0,"TuturialBoss_E":0}
	G.win_to = {"total":0,"TuturialBoss_E":0}

#endregion
