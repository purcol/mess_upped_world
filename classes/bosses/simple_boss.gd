## Базовый класс для всех вобов
class_name SimpleBoss
extends CharacterBody2D

## фаза и нормолизированный процент её начала
@export var stages:Dictionary[int,float] = {}
#мусор данных обучающего босса
	#1:1.0,
	#2:0.8,
	#3:0.3}
## Совсем не неудобный словарь с 1 списком всех стрелков(и их вкл./выкл.) на 1 фазу. Очень большие костыли тут ^^^.
@export var stage_stats:Dictionary[int,Dictionary] = {}
#мусор данных обучающего босса
	#1:{
		#"Shoter_CN1":true,
		#"Shoter_CS1":false,"Shoter_CS2":false,"Shoter_CS3":false,
		#"LazerShoterC1":false,"LazerShoterC2":false,"LazerShoterC3":false,"LazerShoterC4":false,
		#"LazerShoterCC1":false,"LazerShoterCC2":false,"LazerShoterCC3":false,"LazerShoterCC4":false},
	#2:{
		#"Shoter_CN1":true,
		#"Shoter_CS1":true,"Shoter_CS2":true,"Shoter_CS3":true,
		#"LazerShoterC1":false,"LazerShoterC2":false,"LazerShoterC3":false,"LazerShoterC4":false,
		#"LazerShoterCC1":false,"LazerShoterCC2":false,"LazerShoterCC3":false,"LazerShoterCC4":false},
	#3:{
		#"Shoter_CN1":true,
		#"Shoter_CS1":true,"Shoter_CS2":true,"Shoter_CS3":true,
		#"LazerShoterC1":true,"LazerShoterC2":true,"LazerShoterC3":true,"LazerShoterC4":true,
		#"LazerShoterCC1":true,"LazerShoterCC2":true,"LazerShoterCC3":true,"LazerShoterCC4":true}
	#}

var current_stage:int = 1
var previos_stage:int = 1
var healf_procent:float = 100


func _ready() -> void:
	update_stage()

func update_stage():
	for node in get_node("Components").get_children():
		if node.name != "XitboxArea_C":
			if node.name != "Healf_C":
				for nested_nodes in node.get_children():
							nested_nodes.is_on = stage_stats[current_stage][nested_nodes.name]

func _process(_delta: float) -> void:
	healf_procent = $Components/Healf_C.healf/$Components/Healf_C.max_healf
	#print_debug(current_stage," | ",stages," | ",healf_procent)
	
	for i in range(len(stages)):
		if healf_procent <= stages[abs(i-len(stages))]:
			current_stage = abs(i-len(stages))
			break
	# ^ == \/
	#if healf_procent <= stages[3]:
		#current_stage = 3
	#elif healf_procent <= stages[2]:
		#current_stage = 2
	#elif healf_procent <= stages[1]:
		#current_stage = 1
	if current_stage != previos_stage:
		update_stage()
	previos_stage = current_stage
	if get_tree().get_first_node_in_group("Player") != null:
		look_at(get_tree().get_first_node_in_group("Player").position)
