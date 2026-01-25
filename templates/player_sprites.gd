extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	if $"../../.." != null:
		if $"../../..".get_name() == "Player_E":
			visible = true
			if name == "LazerShoterC":
				if $"..".can_player_shoot:
					visible = true
				else:
					visible = false

func _process(_delta: float) -> void:
	if $"../../.." != null:
		if $"../../..".get_name() == "Player_E":
			rotate(-0.01)
			#print("cps in sprite:    ",$"..".can_player_shoot)
			if name == "LazerShoterC":
				if $"..".can_player_shoot:
					visible = true
				else:
					off()

func off() -> void:
	await get_tree().create_timer($"..".cast_delay).timeout
	visible = false
