extends Node2D

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_line(Vector2.ZERO,Vector2(0,-100*$"../MiniGameFlappyBird".up_velocity),Color.AQUA, 5)
	draw_line(Vector2.ZERO,Vector2(0,100*$"../MiniGameFlappyBird".down_velocity),Color.BLUE, 5)
	draw_line(Vector2.ZERO,Vector2(0,-100*$"../MiniGameFlappyBird".velocity),Color(1.0, 1.0, 1.0, 0.451), 5)
