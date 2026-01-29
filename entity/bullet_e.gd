extends CharacterBody2D

@export var damage:float = 1.0
var target_player:bool = false


func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_xitbox_area_c_area_entered(area: Area2D) -> void:
	G.print_log("EntityFrequentInteractions", ["From ",$".".name,". Hited entity ID: ", area.entity_id,"."])
	if area.entity_id == "Bullet_E":
		return
	if area.get_name() == "XitboxArea_C":
		target_player = area.is_player()
	area.hit(damage)
	queue_free()
