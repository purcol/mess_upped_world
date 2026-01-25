@tool
extends GameWeaponLazerShoter

var can_player_shoot:bool = true

func _process(_delta: float) -> void:
	if entity.is_in_group("Player"):
		#print("can_player_shoot: ",can_player_shoot)
		if Input.is_action_just_pressed("shot"):
			if can_player_shoot: 
				can_player_shoot = false
				defalt_shot(1)
				reload_shot()
	super(_delta)
#
func shot_condition() -> void:
	if entity.is_in_group("Player"):
		shot_condition_flag = false
	super()

func auto_shot() -> void:
	if entity.is_in_group("Player"): pass
	super()

func _ready() -> void:
	if entity.is_in_group("Player"):
		on_timer = true
		cooldown = 1.5
		damage = 2
	super()

func reload_shot() -> void:
	if Engine.is_editor_hint(): return
	if !entity.is_in_group("Player"): return
	if !can_player_shoot:
		await get_tree().create_timer(cooldown).timeout
		can_player_shoot = true
