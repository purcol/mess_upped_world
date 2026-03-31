extends Node2D

#var safe_to_kill:bool = false
var player:Node
var boss:Node


func _ready() -> void:
	Input.set_custom_mouse_cursor(G.AIM_CURSOR,Input.CURSOR_ARROW)
	if GEntyties.selected_boss == GEntyties.BossesID.NONE:
		push_error("ERROR: selected_boss == 0 (NONE). Returning to main menu.")
		get_tree().change_scene_to_file("res://worlds/pease.tscn")
		return
	if GDebug.hide_backround.get("BattelZone"):
		$Beackroung.visible = false
	add_child(load(GEntyties.BOSSES[GEntyties.selected_boss]+str(GEntyties.selected_difficulty)+".tscn").instantiate())
	GDebug.print_log("WorldActions", ["Boss added to the tree."])
	boss = get_tree().get_first_node_in_group("Boss")
	player = get_tree().get_first_node_in_group("Player")
	GDebug.print_log("WorldActions", ["Boss: ",boss," / Player: ", player])

func kill_boss() -> void:
	if boss != null:
		boss.queue_free()
		GDebug.print_log("WorldActions", ["Boss killed."])
	else: push_error("ERROR!| boss in null!")

func setup_end_game(how_called:Node) -> void:
	GDebug.print_log("WorldActions", ["Setting up endgame."])
	if !how_called.is_in_group("Player") or !how_called.is_in_group("Boss"): return
	for node in get_tree().get_nodes_in_group("HealfText"):
		node.visible = false
	for node in get_tree().get_nodes_in_group("Weapon"):
		node.is_on = false

func end_game(how_called:Node) -> void:
	GDebug.print_log("WorldActions", ["Starting endgame."])
	setup_end_game(how_called)
	var boss_name = boss.name
	GDebug.print_log("WorldActions", ["Endgame boss name: ",boss_name])
	if how_called.is_in_group("Player"):
		GDebug.print_log("WorldActions", ["Endgame type loss (0)."])
		var loses = GSaves.died_to["total"]
		var lose_to_boss = GSaves.died_to[boss_name]
		GSaves.died_to["total"] = loses + 1
		GDebug.print_log("WorldActions", ["Total loses added."])
		GSaves.died_to[boss_name] = lose_to_boss + 1
		GDebug.print_log("WorldActions", [boss_name," loses added."])
		get_tree().get_first_node_in_group("Camera").get_node("EndSreen").show_end_screen(0)
	elif how_called.is_in_group("Boss"):
		GDebug.print_log("WorldActions", ["Engame type win (1)."])
		var wins = GSaves.win_to["total"]
		var wins_to_boss = GSaves.win_to[boss_name]
		GSaves.win_to["total"] = wins + 1
		GDebug.print_log("WorldActions", ["Total wins added."])
		GSaves.win_to[boss_name] = wins_to_boss + 1
		GDebug.print_log("WorldActions", [boss_name," wins added."])
		get_tree().get_first_node_in_group("Camera").get_node("EndSreen").show_end_screen(1)
	else: push_error("ERROR!| Node "+str(how_called)+" is not in Player or Boss groop!"); return
	get_tree().paused = true
	GDebug.print_log("WorldActions", ["Game paused."])
	kill_boss()
