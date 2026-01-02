## Базовый класс для всех стрелков
class_name GameWeaponShoter
extends Node2D

@onready var bullet_scene_exemplar = preload("res://entity/bullet_e.tscn")

## конфигурация стрелка
@export_category("Sooter config")
## если `true` целится в оппонента
@export var aim_oppenent:bool = false
## добавляет пулю не в `FunctionalEntities`, а в себя
@export var is_local:bool = false
## включает выключает стрельбу
@export var is_on:bool = true
@export var is_nasted:bool = false
## +abs((макс_хп-хп)*speed_multiplayer)
@export var speed_multiplayer:float = 0.0
## максимальное умножение
@export var max_modifire:float = 3.0
## ждёт заданное время перед началом работы
@export var time_offset:float = 0.0

## конфигурация пули
@export_category("Bullet config")
## сцена которую надо призывать
@export var bullet_scene := load("res://entity/bullet_e.tscn")
## направление пули
@export var direction:Vector2 = Vector2(1,0) : 
	get: return direction
	set(vector): direction = vector.normalized(); #if direction == Vector2(0,0): push_warning("Warning | Bullet direction = 0!")
## скорость пули (если сценой для призыва будет лазером работает как длина (для лазеров нужно использовать `GameWeaponLazerShoter` класс))
@export var speed:float = 200
## урон пули
@export var damage:float :
	get: return damage
	set(amount): damage = abs(amount)

## конфигурации связанные со временем
@export_category("Timer")
##будет ли стрелять автоматически (на timeout)
@export var on_timer:bool = false : 
	get:
		return on_timer
	set(_is_on):
		on_timer = _is_on
		needs_update_auto_shot = true

##будет ли уничноженно после первого выстрела
@export var one_shot:bool = false
##промежуток между выстрелами. Для работы нужен on_timer = ture
@export var cooldown:float = 1.0
##применяется ли ускорение к cooldown. (уменьшает его)
@export var use_speed_mod_on_cooldown:bool = false

@onready var entity = get_node("../..")

@export_category("Debug")
@onready var is_palyer = entity.is_in_group("Player")

var needs_update_auto_shot:bool = false
var is_auto_shoot_on:bool = false
## когда true стрельяет
var shot_condition_flag:bool = false


func get_bullet_collision() -> int:
	if is_palyer: return 6
	return 5

#region speed_modifire
##возращает ускорение 
func get_speed_modifire(max_hp:float,hp:float,speed_per_hp:float,max_value:float) -> float:
	#print((1-((hp/(max_hp*0.01))*0.01))," ",max_hp," ",hp)
	return clamp(abs((1-((hp/(max_hp*0.01))*0.01))*speed_per_hp),1,max_value)

##возращает ускорение текущей сущьности
func get_entity_speed_modifire() -> float:
	if Engine.is_editor_hint(): return 1.0
	if entity.get_node("Components").has_node("Healf_C"):
		var hp_node = entity.get_node("Components/Healf_C")
		return get_speed_modifire(hp_node.max_healf, hp_node.healf, speed_multiplayer,max_modifire)
	return 1.0
#endregion

func get_oppenent() -> Node:
	var oppenent = get_tree().get_first_node_in_group("Player")
	if is_palyer: oppenent = get_tree().get_first_node_in_group("Boss")
	if oppenent == null: oppenent = get_tree().get_first_node_in_group("World"); push_warning("Warning | Oppenent is null!")
	return oppenent

#region стрельба
##вызывает выстрел
func shot(bullet:Resource,bullet_direction:Vector2,bullet_speed:float,bullet_damage:float,is_targeting_opponent:bool=false,spawn_as_local:bool=false,_num:int=-1) -> void:
	if Engine.is_editor_hint(): return
	if !is_on: return
	#print("INFO| shot happend ",num)
	var bullet_inst = bullet.instantiate()
	
	bullet_inst.global_position = self.global_position
	var parent_node = get_tree().get_first_node_in_group("World").get_node("FunctionalEntities")
	if spawn_as_local: parent_node = get_node("."); bullet_inst.position = Vector2(0,0)
	bullet_inst.get_node("Components/XitboxArea_C").set_collision_mask(get_bullet_collision())
	bullet_inst.velocity = bullet_direction*bullet_speed
	if is_targeting_opponent: bullet_inst.velocity = ((get_oppenent().global_position-self.global_position).normalized())*bullet_speed + bullet_direction*bullet_speed
	bullet_inst.damage = bullet_damage
	
	parent_node.add_child(bullet_inst)
	return

func defalt_shot(num:int=0) -> void:
	shot(bullet_scene,direction,speed*get_entity_speed_modifire(),damage*get_entity_speed_modifire(),aim_oppenent,is_local,num)
	#print("INFO| defalt_shot")
	return
#endregion

##запускает авто стрельбу
func auto_shot() -> void:
	if Engine.is_editor_hint(): return
	if !is_auto_shoot_on:
		is_auto_shoot_on = true
		while on_timer:
			await get_tree().create_timer(cooldown).timeout
			defalt_shot(1)
			#print("INFO| auto_shot")
	is_auto_shoot_on = false
	return

func shot_condition() -> void:
	#тут писать код для проверки
	pass

func _ready() -> void:
	if is_nasted: entity = get_node("../../..")
	await get_tree().create_timer(time_offset).timeout
	auto_shot()
	#print("INFO| ready auto_shot")
	return

func _physics_process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		shot_condition()
		if shot_condition_flag and !on_timer:
			defalt_shot()
			shot_condition_flag = false
			#print("INFO| scf defalt_shot")
		if needs_update_auto_shot: 
			needs_update_auto_shot = false
			auto_shot()
			#print("INFO| nuas auto_shot")
			return
