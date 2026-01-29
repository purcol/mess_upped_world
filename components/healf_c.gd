extends Node

@export var healf:float = 10.0 : 
	get:
		return healf
	set(amount):
		healf = amount
		if healf < 0:
			G.print_log("EntityInteractions", ["Trying to kill ",$"../..".name,"..."])
			if get_tree().get_first_node_in_group("World").has_method("end_game"):
				get_tree().get_first_node_in_group("World").end_game($"../..")
			else: push_error("ERROR!| World does not have \"end_game\" method!")
@onready var max_healf = healf

func add_healf(amount) -> void:
	if $"../..".get_name() == "Player_E" and G.dev_mode: return
	healf = healf + amount
