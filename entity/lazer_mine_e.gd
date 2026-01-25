extends CharacterBody2D

#@export var speed = 300.0
var duration = 1.5
@export_enum("NONE","OPPENENT","ALLY") var aim = 2 :
	get():
		return aim
	set(amount):
		pass
		#aim == amount
var attack_path:String = ""
var damage:float = 1.0
var owner_rotation:float = 0.0
var owner_position:Vector2 = Vector2(0.0,0.0)
var length:float = 0.0

func _ready() -> void:
	#rotation = owner_rotation
	$Components/LazerShoterC.damage = damage
	$Components/LazerShoterC.speed = length
	$Components/LazerShoterC.aim = aim
	$Components/LazerShoterC.attack_path = attack_path
	var cast_delay = $Components/LazerShoterC.cast_delay
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", velocity+owner_position, (cast_delay*$Components/LazerShoterC.stop_follow)+(cast_delay*0.8)+(cast_delay*0.2)+cast_delay+0.2)

#func _physics_process(_delta: float) -> void:
	#get_tree().create_tween().tween_property(self, "position", velocity, 1.5)
	#velocity.x = move_toward(velocity.x, 0, speed*0.01)
	#print(velocity)
	#move_and_slide()

func _on_lazer_shoter_c_on_shot() -> void:
	await get_tree().create_timer($Components/LazerShoterC.cast_delay+0.1).timeout
	self.queue_free()
	return
