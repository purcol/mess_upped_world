extends Node2D

var safe_to_kill:bool = false
var boss
#var boss_w

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(G.AIM_CURSOR,Input.CURSOR_ARROW)
	if G.selected_boss == G.BossesID.NONE:
		push_error("ERROR: selected_boss == 0 (NONE). Returning to main menu.")
		get_tree().change_scene_to_file("res://worlds/pease.tscn")
		return
	add_child(load(G.BOSSES[G.selected_boss]).instantiate())
	boss = get_tree().get_first_node_in_group("Boss")
	#boss_w = boss.get_node("Components/NormalLazerAttack/LazerShoterCN1")

func kill_boss() -> void:
	if safe_to_kill and get_tree().get_first_node_in_group("Boss") != null:
		get_tree().get_first_node_in_group("Boss").queue_free()



#func _process(_delta: float) -> void:
	#if G.dev_mode and !Engine.is_editor_hint():
		#queue_redraw()
#
#func _draw() -> void:
	#if G.dev_mode and !Engine.is_editor_hint():
		#if boss_w.is_palyer: draw_circle(boss_w.get_predicted_location()-boss_w.global_position,2.5,Color.CORAL)
		#else: draw_circle(boss_w.get_predicted_location(),5,Color.ORANGE)
		#boss.global_position = boss_w.get_predicted_location()
		#print(boss_w.get_oppenent().name," | ",boss_w.get_predicted_location()," | ",boss_w.get_oppenent().global_position," | ",boss_w.get_predicted_location()-boss_w.global_position)
