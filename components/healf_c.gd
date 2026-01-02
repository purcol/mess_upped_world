extends Node

@export var healf:float = 10.0 : 
	get:
		return healf
	set(amount):
		healf = amount
		if healf < 0:
			if $"../..".get_name() == "Player_E":
				G.died_to["total"] += 1
				if get_tree().get_first_node_in_group("Boss") != null:
					G.died_to[get_tree().get_first_node_in_group("Boss").name] += 1
				get_tree().get_first_node_in_group("World").safe_to_kill = true
				
				$"../Camera/LoseSreen".visible = true
				$"../../Sprite2D".visible = false
				$"../../HealfText".visible = false
				get_tree().get_first_node_in_group("World").kill_boss()
				get_tree().paused = true
			if $"../..".is_in_group("Boss"):
				var palyer = get_tree().get_first_node_in_group("Player")
				palyer.get_node("HealfText").visible = false
				palyer.get_node("Sprite2D").visible = false
				
				G.win_to["total"] += 1
				G.win_to[$"../..".name] += 1
				
				var losse_screen = palyer.get_node("Components/Camera/LoseSreen")
				losse_screen.visible = true
				losse_screen.get_node("Title").text = "Победа!"
				losse_screen.get_node("Title/SubTitle").text = "так держать!"
				get_tree().get_first_node_in_group("World").kill_boss()
				get_tree().paused = true
			#$"../..".queue_free()
			#call_deferred("get_tree().change_scene_to_file","res://worlds/pease.tscn")
@onready var max_healf = healf

func add_healf(amount) -> void:
	if $"../..".get_name() == "Player_E" and G.dev_mode: return
	healf = healf + amount
