extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	if $"../../.." != null:
		if $"../../..".get_name() == "Player_E":
			visible = true

func _process(_delta: float) -> void:
	if $"../../.." != null:
		if $"../../..".get_name() == "Player_E":
			rotate(-0.01)
