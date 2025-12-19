class_name SaveGame
extends Resource

@export_category("Stats")
@export var time_played:int = 0
@export var games_played:int = 0
@export var boss_kills:Dictionary = {"TuturialBoss_E":0}
@export var deaf_counder:Dictionary = {"TuturialBoss_E":0}

@export var selected_weapons:Array[String] = []

const PATH = "user://savefile.tres"

func white_savefile() -> void:
	ResourceSaver.save(self, PATH)

func load_savefile() -> Resource:
	if ResourceLoader.exists(PATH):
		return load(PATH)
	else: push_error(Error.ERR_CANT_OPEN," Can't open safe file in: ", PATH)
	return null
