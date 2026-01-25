extends GameWeaponShoter

var charge_time:float = 0

func defalt_shot(_num:int=3) -> void:
	pass

func _process(delta: float) -> void:
	#print(charge_time)
	if Input.is_action_just_pressed("shot"):
		charge_time = 0
	if Input.is_action_pressed("shot"):
		charge_time += delta*2
	if Input.is_action_just_released("shot"):
		shot(bullet_scene,direction,clamp(speed*charge_time,speed*0.01,speed*3)*get_entity_speed_modifire(),clamp(damage*charge_time,damage*0.01,damage*3)*get_entity_speed_modifire(),aim,is_local)
		charge_time = 0

func shot_condition() -> void:
	shot_condition_flag = false
