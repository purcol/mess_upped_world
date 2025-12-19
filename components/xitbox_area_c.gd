extends Area2D

@export var entity_id = ""

func get_xitbox_owner() -> Node:
	var owner_ = get_node("../..")
	return owner_

func get_xitbox_owner_name() -> String:
	var owner_name = get_node("../..").get_name()
	return owner_name

func is_player() -> bool:
	return get_xitbox_owner_name() == "Player_E"

func invinsybility(time) -> void:
	if !$Collision.disabled:
		$Collision.disabled = true
		await get_tree().create_timer(time).timeout
		$Collision.disabled = false

func hit(damage:float=1) -> void:
	if !$Collision.disabled:
		if is_player():
			call_deferred("invinsybility", 0.1)
	if get_node("..").has_node("Healf_C"):
		get_node("../Healf_C").add_healf(-abs(damage))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_node("CollisionExemplar"):
		get_node("Collision").shape = get_node("CollisionExemplar").shape
