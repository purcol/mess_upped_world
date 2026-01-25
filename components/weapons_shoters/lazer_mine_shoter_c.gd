@tool
extends GameWeaponShoter

@export var final_position:Vector2 = Vector2.ZERO
#@export var aiming_offset:Vector2 = Vector2(0.0,0.0)
@export var duration:float = 1.0
var owner_rotation:float = 0.0

func _process(_delta: float) -> void:
	owner_rotation = $"../../..".rotation
	if Engine.is_editor_hint() or G.dev_mode:
		queue_redraw()

func _draw() -> void:
	if G.dev_mode:
		draw_circle(Vector2.ZERO,5,Color.CRIMSON)
	if Engine.is_editor_hint():
		draw_dashed_line(Vector2.ZERO,final_position,Color.CORAL,0.5)
		#draw_dashed_line(final_position,(final_position).normalized()/speed,Color.ORANGE,1)
		draw_circle(final_position,1,Color.ORANGE)
		draw_circle(Vector2.ZERO,1,Color.CRIMSON)

func shot(bullet:Resource,bullet_direction:Vector2,bullet_speed:float,bullet_damage:float,
		  targeting:int=0,_spawn_as_local:bool=false,_num:int=-1) -> void:
	if Engine.is_editor_hint(): return
	if !is_on: return
	on_shot.emit()
	#print("INFO| shot happend ",num)
	var bullet_inst = bullet.instantiate()
	
	bullet_inst.damage = bullet_damage
	bullet_inst.length = speed
	var parent_node = get_tree().get_first_node_in_group("World").get_node("FunctionalEntities")
	bullet_inst.position = self.global_position
	bullet_inst.owner_position = self.global_position
	#bullet_inst.get_node("Components/XitboxArea_C").set_collision_mask(get_bullet_collision())
	bullet_inst.velocity = bullet_direction.rotated(owner_rotation)
	bullet_inst.duration = bullet_speed
	bullet_inst.aim = targeting
	bullet_inst.attack_path = get_parent().name+"/"+name
	bullet_inst.owner_rotation = owner_rotation
	
	parent_node.add_child(bullet_inst)
	return

func defalt_shot(_num:int=0) -> void:
	shot(bullet_scene,final_position,duration,damage,0,true,is_local)
	#print("INFO| defalt_shot")
	return
