extends CharacterBody2D

var stages:Dictionary = {1:1.0,2:0.8,3:0.3}#Shoter_C_storm3
@export var stage_stats:Dictionary = {1:{"Shoter_C":true,"Shoter_C_storm":false,"Shoter_C_storm2":false,"Shoter_C_storm3":false,"LazerShoter_C_cross1":false,"LazerShoter_C_cross2":false,"LazerShoter_C_cross3":false,"LazerShoter_C_cross4":false,"LazerShoter_C_cross5":false,"LazerShoter_C_cross6":false,"LazerShoter_C_cross7":false,"LazerShoter_C_cross8":false},
								2:{"Shoter_C":true,"Shoter_C_storm":true,"Shoter_C_storm2":true,"Shoter_C_storm3":false,"LazerShoter_C_cross1":false,"LazerShoter_C_cross2":false,"LazerShoter_C_cross3":false,"LazerShoter_C_cross4":false,"LazerShoter_C_cross5":false,"LazerShoter_C_cross6":false,"LazerShoter_C_cross7":false,"LazerShoter_C_cross8":false},
								3:{"Shoter_C":true,"Shoter_C_storm":true,"Shoter_C_storm2":true,"Shoter_C_storm3":false,"LazerShoter_C_cross1":true,"LazerShoter_C_cross2":true,"LazerShoter_C_cross3":true,"LazerShoter_C_cross4":true,"LazerShoter_C_cross5":true,"LazerShoter_C_cross6":true,"LazerShoter_C_cross7":true,"LazerShoter_C_cross8":true}}
var current_stage:int = 1
var previos_stage:int = 1
var healf_procent:float = 100

@export var speed:float = 100

func _ready() -> void:
	update_stage()

func update_stage():
	
	if current_stage >= 2:
		$StormSprite.visible =true
		if current_stage == 2:
			get_tree().create_tween().tween_property($StormSprite,"modulate",Color(1,1,1,1),0.1)
	if current_stage == 3:
		$LazerSprite.modulate = Color(1,1,1,0)
		get_tree().create_tween().tween_property($LazerSprite,"modulate",Color(1,1,1,1),0.1)
		get_tree().create_tween().tween_property($lazerCoverUpSprite,"modulate",Color(1,1,1,0),0.1)
	for node in get_node("Components").get_children():
		if node.name != "XitboxArea_C":
			if node.name != "Healf_C":
				node.is_on = stage_stats[current_stage][node.name]

func _process(_delta: float) -> void:
	if get_tree().get_first_node_in_group("Player") != null:
		velocity = (get_tree().get_first_node_in_group("Player").global_position - global_position).normalized()*speed
	healf_procent = $Components/Healf_C.healf/$Components/Healf_C.max_healf
	#print(stages[3],healf_procent <= stages[3],healf_procent)
	
	if healf_procent <= stages[3]:
		current_stage = 3
	elif healf_procent <= stages[2]:
		current_stage = 2
	elif healf_procent <= stages[1]:
		current_stage = 1
	if current_stage != previos_stage:
		update_stage()
	previos_stage = current_stage
	if get_tree().get_first_node_in_group("Player") != null:
		look_at(get_tree().get_first_node_in_group("Player").position)

func _physics_process(_delta: float) -> void:
	move_and_slide()
