extends CharacterBody2D

@export var margin_of_error:int = 20
@export_enum("hower_mouse","jump") var MovementType: int = 0
@export var weapons:Array[String] = ["shoter"]

@export var speed = 300.0
#настроавает скорость остановки
@export var sliperness:float = 0.1

#настроавает растояние с котороко начинается уменьшение скорости
@export var weakering_radius:float = 0.015

func _ready() -> void:
	weapons = G.selected_weapons
	add_weapons()

#func _process(_delta: float) -> void:
	#$Sprite2D.look_at(get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	match MovementType:
		0: hower_mouse_movement()
		1: pass

	move_and_slide()

#добавление оружий
func add_weapons():
	for weapon in weapons:
		var weapon_exemplar = load("res://components/weapons_shoters/"+weapon+"_c.tscn")
		var weapon_inst = weapon_exemplar.instantiate()
		weapon_inst.on_timer = true
		$Components.add_child(weapon_inst)

#наведение на курсор
func hower_mouse_movement() -> void:
	var mouse_pos = get_local_mouse_position()
	var distanse = abs(global_position - get_global_mouse_position())
	velocity = mouse_pos.normalized()*speed
	velocity.x *= clamp(distanse.x*weakering_radius,0,1)
	velocity.y *= clamp(distanse.y*weakering_radius,0,1)
