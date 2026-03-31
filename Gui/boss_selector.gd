extends HBoxContainer


var path_to_bosses_panels:String = "res://bosses/"
var boss_list:Array[String] = []
var index_:int = 0

var has_ready_updated:bool = false

func _ready() -> void:
	if Engine.is_editor_hint(): return
	for scene in DirAccess.open(path_to_bosses_panels).get_files():
		if str(scene).split(".")[1] == "tscn":
			var button = load(str(path_to_bosses_panels,scene)).instantiate()
			#button.button_group = load("res://Gui/buttons/groups/achievements.tres")
			#button.position += Vector2(0,size.y*scale.y)
			button.scale = scale
			boss_list.append(button.name)
			$"../".call_deferred("add_child",button)

func _process(_delta: float) -> void:
	if !Engine.is_editor_hint(): 
		if !has_ready_updated: update_visibility(); has_ready_updated = true
		$Title.text = $"../".get_node(boss_list[index_]).boss_name

func update_visibility() -> void:
	if Engine.is_editor_hint(): return
	for node_index in boss_list:
		$"../".get_node(node_index).visible = false
		$"../".get_node(node_index).mouse_filter = Control.MOUSE_FILTER_IGNORE
	$"../".get_node(boss_list[index_]).visible = true
	$"../".get_node(boss_list[index_]).mouse_filter = MOUSE_FILTER_STOP

func _on_left_pressed() -> void:
	if Engine.is_editor_hint(): return
	index_ = clamp(index_-1, 0, boss_list.size()-1)
	update_visibility()
	#print(index," ", boss_list[index_]," ", boss_list)


func _on_right_pressed() -> void:
	if Engine.is_editor_hint(): return
	index_ = clamp(index_+1, 0, boss_list.size()-1)
	update_visibility()
	#print(index," ", boss_list[index]," ", boss_list)
