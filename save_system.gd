extends Node

var save_location = "user://save_file.json"

var contents_to_save:Dictionary = {
	"selected_weapons":[""]#shoter
}


func _save():
	var file = FileAccess.open(save_location,FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location,FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		G.selected_weapons = save_data.selected_weapons
