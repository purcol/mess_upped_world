extends Node2D

var safe_to_kill:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if G.selected_boss == G.BossesID.NONE:
		push_error("ERROR: selected_boss == 0 (NONE). Returning to main menu.")
		get_tree().change_scene_to_file("res://worlds/pease.tscn")
		return
	add_child(load(G.BOSSES[G.selected_boss]).instantiate())

func kill_boss() -> void:
	if safe_to_kill and get_tree().get_first_node_in_group("Boss") != null:
		get_tree().get_first_node_in_group("Boss").queue_free()
