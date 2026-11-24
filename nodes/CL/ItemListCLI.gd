@tool
extends MonitorCLI
class_name ItemListCLI
## Этот CLI показывает все ресурсы оружий. (см. [WeaponsCLI])

var item_list:Array[ItemResource]

func _ready() -> void:
	super._ready()

func load_items(load_folder_name:String) -> void:
	for file in DirAccess.get_files_at("res://resources/"+load_folder_name):
		item_list.append(ResourceLoader.load("res://resources/"+load_folder_name+"/"+file))
		if !Engine.is_editor_hint() and item_list.size() >0: item_list[-1].generate_word_effects()
	scroll_max = max(0,item_list.size()-line_size.x)
	is_scrollable = scroll_max > 0

func generic_draw_ui() -> void:
	pre_effects()
	draw_ver_line(line_size.x)
	draw_scroll_bar(1,0)
	var counter:int=0
	for weapon:ItemResource in item_list:
		if !Engine.is_editor_hint(): create_button(weapon.get_title(),Vector2(counter,0),line_size.x-4,load("res://nodes/CL/weapons/buttons_scripts/update_preview.gd"),{"item":weapon})
		else: create_button("ОРУЖИЕТУТ",Vector2(counter,0),line_size.x-4)
		counter += 1
	#create_button("ОРУЖИЕТУТ",Vector2(0,0),true)
	aplly_all_effects()

func draw_ui() -> void:
	if !Engine.is_editor_hint():
		generic_draw_ui()

func editor_draw_ui() -> void:
	generic_draw_ui()

func _on_wire_input_changed(_input:Array[Variant]):
	pass
