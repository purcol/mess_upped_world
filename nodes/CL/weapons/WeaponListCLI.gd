@tool
extends ItemListCLI
class_name WeaponListCLI

var active_weapons_list:Array[ItemResource] = []
var passve_weapons_list:Array[ItemResource] = []
var files_count:Array[int] = [0,0]

func _ready() -> void:
	load_active_weapons_list()
	super._ready()

func load_active_weapons_list() -> void:
	#если в папке одинаковое количество файлов, то загрузка по новой пропускается
	if DirAccess.get_files_at("res://resources/weapons/").size() != files_count[0]:
		for file in DirAccess.get_files_at("res://resources/weapons/"):
			var res:WeaponResource = ResourceLoader.load("res://resources/weapons/"+file)
			if !res.is_passive: active_weapons_list.append(res)
			if !Engine.is_editor_hint() and passve_weapons_list.size() >0: active_weapons_list[-1].generate_word_effects()
		scroll_max = max(0,item_list.size()-line_size.x)
		is_scrollable = scroll_max > 0
		files_count[0] = DirAccess.get_files_at("res://resources/weapons/").size()
	item_list = active_weapons_list
	draw_ui()

func load_passve_weapons_list() -> void:
	#если в папке одинаковое количество файлов, то загрузка по новой пропускается
	if DirAccess.get_files_at("res://resources/weapons/").size() != files_count[1]:
		for file in DirAccess.get_files_at("res://resources/weapons/"):
			var res:WeaponResource = ResourceLoader.load("res://resources/weapons/"+file)
			if res.is_passive: passve_weapons_list.append(res)
			if !Engine.is_editor_hint() and passve_weapons_list.size() >0: passve_weapons_list[-1].generate_word_effects()
		scroll_max = max(0,item_list.size()-line_size.x)
		is_scrollable = scroll_max > 0
		files_count[1] = DirAccess.get_files_at("res://resources/weapons/").size()
	item_list = passve_weapons_list
	draw_ui()

func generic_draw_ui() -> void:
	super.generic_draw_ui()
	$"../WeaponsCLI".set_char_from_text(Vector2i(2,line_size.x-1),get_char(0b0111))
	$"../WeaponsCLI".set_char_from_text(Vector2i($"../WeaponsCLI".line_size.y-1,line_size.x-1),get_char(0b1011))
