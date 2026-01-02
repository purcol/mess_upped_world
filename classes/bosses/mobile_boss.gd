class_name MobileBoss
extends SimpleBoss

## фаза и скорость
@export var speed:Dictionary[int,float] = {}

func _physics_process(_delta: float) -> void:
	#print(get_tree().get_first_node_in_group("Player") != null, " | ",get_tree().get_first_node_in_group("Player").global_position - global_position, " | ",(get_tree().get_first_node_in_group("Player").global_position - global_position).normalized(), " | ",(get_tree().get_first_node_in_group("Player").global_position - global_position).normalized()*speed)
	if get_tree().get_first_node_in_group("Player") != null:
		velocity = (get_tree().get_first_node_in_group("Player").global_position - global_position).normalized()*speed[current_stage]
	move_and_slide()
