@tool
class_name GameMenuBossButton
extends SimpleAchiementButton

@export_category("Boss Button")
#@export var boss = G.BossesID
@export_enum("NONE", "TUTORIAL_BOSS_E", "LAZER_TAG_BOSS_E") var boss:int = 0

func _ready() -> void:
	super()
	change_scene = load("res://worlds/battel_zone.tscn")

func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		G.selected_boss = boss as int
	super(toggled_on)

func _process(_delta: float) -> void:
	super(_delta)
