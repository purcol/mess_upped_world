extends Sprite2D


func _ready() -> void:
	visible = false
	if $"..".entity != null:
		if $"..".entity.is_in_group("Player"):
			if $"..".can_player_shoot: visible = true
			else: visible = false

func _process(_delta: float) -> void:
	if $"..".entity.is_in_group("Player"):
		if $"..".name == "LazerShoterC":
			if $"..".can_player_shoot: visible = true
			else: off()
		rotate(-0.01)

##Скрывает спрайт с учётом cast_delay лазера.
func off() -> void:
	await get_tree().create_timer($"..".cast_delay).timeout
	visible = false
