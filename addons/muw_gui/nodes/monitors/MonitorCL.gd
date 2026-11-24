@icon("res://addons/muw_gui/textures/icons/MonitorCL.svg")
@tool
@abstract
extends RichTextLabel
## Поле текста с координатами на котором можно рисовать простые фигуры или отображать текст.
## @experimental: системы коордикат могут постотяно менятся (строка,символ / x,y). И имеет слишком много всего (+400 сток отборных спагетти в стиле альденто)
class_name MonitorCL

## Размер в строках.
var line_size:Vector2i

## Enum со кодов эффектов. 
enum BBC_CODES {BOSS=0,DIFFICULTY=1,MOVEMENT=2,NODE=3,WARNING=4,WEAPON=5}
## ключь [member BBC_CODES] : код соответствующего эффекта
var effects:Dictionary[BBC_CODES,String] = {BBC_CODES.BOSS:"boss_effect",
											BBC_CODES.DIFFICULTY:"difficulty_effect",
											BBC_CODES.MOVEMENT:"movement_effect",
											BBC_CODES.NODE:"node_effect",
											BBC_CODES.WARNING:"warning_effect",
											BBC_CODES.WEAPON:"weapon_effect"}
## ключь [member BBC_CODES] : список слов к которым надо прменить эффект 
var search_words_dictionary:Dictionary[int,Array] = {BBC_CODES.BOSS:[],
													BBC_CODES.DIFFICULTY:[],
													BBC_CODES.MOVEMENT:["отпр"],
													BBC_CODES.NODE:[],
													BBC_CODES.WARNING:[],
													BBC_CODES.WEAPON:[]}

#region exports
## Если [code]true[/code], ставится на [code]false[/code] и округляет координаты.
@export var round_pos:bool = false
@export_category("Characters")
## Размер 1 глифа.
## @experimental: размеры символа не рассчитаны идеально.
@export var char_size:Vector2 = Vector2(12.03,29.35) #Vector2(37,8.875)
## Пустой Символ.
@export var empty_char:String = " "
## Символ для горизонтальной линии.
@export var hor_line_car:String = "‒"
## Символ для вертикальной линии.
@export var ver_line_car:String = "┃"
## Символ для пересечения линий.
@export var cross_line_char:String = "┼"
## Символ для стрелки вверх.
@export var up_arrow_char:String = "▲"
## Символ для стрелки вниз.
@export var down_arrow_char:String = "▼"
## Символ для стрелки вниз.
@export var point_char:String = "∎"
## cahrs_atlas это список символов отсортированных по направлениям используя двоичный код. 
## Символы из этой переменой рекомендуется получать через [method get_char]. См. [method get_char]
## @experimental: в коде обычно используется отдельные переменые для символов (когда это возможно).
@export var cahrs_atlas:Array[String] = [" ", "", "", "‒",
										  "", "⌜", "⌝", "┬",
										  "", "⌞", "⌟", "┴",
										  "┃", "├", "┤", "┼"]
#0000 0  " "   0100 4  ""   1000 8  ""   1100 12 ┃
#0001 1  ""    0101 5  ⌜    1001 9  ⌞    1101 13 ├
#0010 2  ""    0110 6  ⌝    1010 10 ⌟    1110 14 ┤
#0011 3  ‒     0111 7  ┬    1011 11 ┴    1111 15 ┼

@export_category("Scroling")
## Решает будет ли монитор прокручиваемым или нет и будет ли отрисововаться скрол бар.
@export var is_scrollable:bool = false
## Максимальное количество строк на которое можно прокрутить текст.
@export var scroll_max:int = 5
## Количество строк на которое прокручен текст.
@export var scroll_progress:int = 0 :
	set(val): 
		scroll_progress = val
		if Engine.is_editor_hint(): editor_draw_ui()
## Оффсет скролбара.
@export var scroll_bar_offset:int = 0
#endregion exports

##размер на момент последней проверки
@onready var last_size:Vector2 = size
## Каждый тик это 1 проверка, и пока не наберётся нужное кол-во тиков, обновление текста не произойдёт.
var ignore_tick:int = 0

var draw_ui_on_ready:bool = true

func _validate_property(property: Dictionary) -> void:
	var n = property.name
	if n == "bbcode_enabled" or \
		n == "context_menu_enabled" or \
		n == "clip_contents" or \
		n == "autowrap_mode" or \
		n == "scroll_active" or \
		n == "justification_flags" or \
		n == "focus_neighbor_bottom" or \
		n == "focus_neighbor_top" or \
		n == "focus_mode" or \
		n == "anchor_bottom" or \
		n == "anchor_right":
			property.usage |= PROPERTY_USAGE_READ_ONLY

func _ready() -> void:
	#region signals
	if !is_connected("resized",Callable(self,"_on_resized")):
		connect("resized",Callable(self,"_on_resized"))
	if !is_connected("gui_input",Callable(self,"_on_gui_input")):
		connect("gui_input",Callable(self,"_on_gui_input"))
	add_theme_font_override("normal_font",load("res://addons/muw_gui/font/MUWFontTestV5.1.otf"))
	add_theme_font_size_override("normal_font_size",27)
	add_theme_stylebox_override("normal",StyleBoxEmpty.new())
	if get_node("../").has_signal("wire_input_changed"):
		get_node("../").connect("wire_input_changed",_on_wire_input_changed)
	#endregion signals
	#region property setup
	bbcode_enabled = true
	context_menu_enabled = false
	clip_contents = true
	autowrap_mode = TextServer.AUTOWRAP_OFF; scroll_active = false
	justification_flags = TextServer.JUSTIFICATION_NONE
	focus_neighbor_bottom = self.get_path(); focus_neighbor_top = self.get_path()
	focus_mode = Control.FOCUS_CLICK
	scale = Vector2(1.25,1.25); custom_minimum_size = char_size
	shortcut_keys_enabled = false
	#endregion property setup
	#region anchors
	set_anchors_preset(Control.PRESET_FULL_RECT)
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH
	#endregion anchors
	#region init
	custom_effects = []
	install_effect(RichTextBossEffect.new())
	install_effect(RichTextDifficulty.new())
	install_effect(RichTextMovementEffect.new())
	install_effect(RichTextNodeEffect.new())
	install_effect(RichTextWarningEffect.new())
	install_effect(RichTextWeaponEffect.new())
	
	line_size = calculate_size()
	fill_with()
	if !Engine.is_editor_hint() and draw_ui_on_ready:
		draw_ui()
	else:
		editor_draw_ui()
	#endregion init

@abstract func _on_wire_input_changed(input:Array[Variant]) -> void
	## do something
func _process(_delta: float) -> void:
	if round_pos: 
		round_pos = false
		await get_tree().create_timer(0.1).timeout
		round_pos_()
		editor_draw_ui()

#region data
## Вычисляет размер ноды в линиях.
func calculate_size() -> Vector2i:
	return Vector2i(floori(size.x/char_size.x),floori(size.y/char_size.y))

#TODO: починить функцию.
## Округляет позицию для удобного расположения нод.
func round_pos_() -> void:
	print(position)
	position = get_local_text_position( 
		Vector2i(floori(position.x/char_size.x),
		floori(position.y/char_size.y)) 
		) + Vector2(40,40) - position
	print(position)
#endregion data

#region get & set
## Получает символы из [member cahrs_atlas].
## Число следует писать в двоичном виде, хоть метод может работать и с обычными числами.
## [codeblock]
## # Последовательность сторон: верх, низ, лево, право.
## print(get_char(0b1100)) # -> "┃"
## print(get_char(0b1111)) # -> "┼"
## print(get_char(0b0111)) # -> "┬"
## [/codeblock]
func get_char(char_code:int) -> String:
	return cahrs_atlas[int(char_code)]

## Получает символы из [member text], используя координаты [param pos].
func get_char_from_text(pos:Vector2i) -> String:
	if pos.y > line_size.x-1 or pos.x > line_size.y-1: return ""
	return text.split("\n")[pos.x][pos.y]

func set_char_from_text(pos:Vector2i,char:String) -> void:
	if pos.y > line_size.x-1 or pos.x > line_size.y-1: return
	var split_text = text.split("\n")
	split_text[pos.x][pos.y] = char
	text = "\n".join(split_text)

##Возвращает локальную позицию символа в тексте.
func get_local_text_position(pos:Vector2i) -> Vector2:
	return Vector2(pos.y+1,max(pos.x-scroll_progress, 0)) * char_size

##Возвращает глобальную позицию символа в тексте.
func get_global_text_position(pos:Vector2i) -> Vector2:
	return (Vector2(pos) * char_size)+global_position
#endregion get & set

#TODO: оптимизировать отрисовку вертикальных линий.
#region drawing
## Функция для груписования [method MonitorCL.draw_*] функций в не редактора.
@abstract func draw_ui() -> void

## Функция для груписования [method MonitorCL.draw_*] функций в редакторе.
func editor_draw_ui() -> void:
	if Engine.is_editor_hint():
		generic_draw_ui()
		pre_effects(true)
		post_effects()
		draw_text(str(line_size.x)+"┃"+str(line_size.y),Vector2i(-1,0),false)

## Функция для груписования [method MonitorCL.draw_*] функций с обоих сторон.
func generic_draw_ui() -> void: pass

#region groop func
## Функция для отрисовки основного инетрсейса.
func draw_core_ui() -> void:
	draw_border()
	fix_broken_corners()

## Выполнение методов-пост эффектов и методов которые должны выполнятся перед остальным рисованием
func pre_effects(calculate_size:bool=false) -> void:
	line_size = calculate_size()
	fill_with()

## Выполнение методов-пост эффектов и методов которые должны выполнятся в самом конце рисования
func post_effects(do_core_ui:bool=true,aplly_effects:bool=true,try_scroll_bar:bool=true) -> void:
	draw_core_ui()
	if is_scrollable: draw_scroll_bar()
	if is_scrollable && try_scroll_bar: draw_scroll_bar()
	if aplly_effects: aplly_all_effects()

func aplly_all_effects() -> void:
	find_and_set_bbc_list(BBC_CODES.BOSS)
	find_and_set_bbc_list(BBC_CODES.DIFFICULTY)
	find_and_set_bbc_list(BBC_CODES.MOVEMENT)
	find_and_set_bbc_list(BBC_CODES.NODE)
	find_and_set_bbc_list(BBC_CODES.WARNING)
	find_and_set_bbc_list(BBC_CODES.WEAPON)

func find_and_set_bbc_list(bbc_code:BBC_CODES) -> void:
	for string in search_words_dictionary[bbc_code]:
		if string != "": find_and_set_bbc(string,bbc_code)
#endregion

## Находит строку [param what] в [member text]
## и задаёт всем найденым совподениям bbc с кодом [param bbc_code].
func find_and_set_bbc(what:String,bbc_code:BBC_CODES,param:Variant=1) -> void:
	if what == "": push_warning('"find_and_set_bbc()" was called with what=="" or bbc_code="" in '+str(get_path())); return
	
	var cursor:int = 0
	var entryes:Array[int] = []
	
	while true:
		entryes.append(text.find("отпр",cursor))
		if entryes[-1] == -1: entryes.remove_at(-1); break
		cursor += what.length()+entryes[-1]
	#print(entryes, cursor)
	
	for pos in entryes:
		text = text.insert(pos+what.length(), "[/{0}]".format([effects[bbc_code]]))
		if param==null: text = text.insert(pos, ("[{0}]").format([effects[bbc_code]]))
		else: text = text.insert(pos, ("[{0}{1}]").format([effects[bbc_code]," dif"+str(param)]))

## Заполняет облость размером [member line_size] символом char.
func fill_with(char:String=empty_char) -> void:
	text = ""
	for i in range(line_size.y):
		for j in range(line_size.x):
			text += char
		text += "\n"
	text.rstrip("\n")

## Рисует горизонтальную линию из [member hor_line_car] на строке [param pos]. Если сталкивается с
## [member ver_line_car] и [param ignore_crosses] равен [code]false[/code], то заменяется на [member cross_line_char].
func draw_hor_line(pos:int,c_char:String="‒",ignore_crosses:bool=false,replace_char:bool=true,is_pos_global:bool=false) -> void:
	pos -= 1
	if pos > line_size.y: return
	if !is_pos_global:
		if pos-scroll_progress < 0: return
		pos = max(pos-scroll_progress,0)
	
	var split_text := text.split("\n")
	var cross_poses:Array[int]=[] #cross_poses содержит положения для cross_line_char в строке
	var filled_poses:Dictionary[int,String]={}
	if replace_char:
		if !ignore_crosses: for i in line_size.x: if split_text[pos][i] == ver_line_car: cross_poses.append(i)
	else: for i in line_size.x: if split_text[pos][i] != empty_char: filled_poses[i] = split_text[pos][i]
	split_text[pos] = c_char.repeat(line_size.x)
	
	if replace_char:
		if !ignore_crosses: for i in cross_poses: split_text[pos][i] = cross_line_char
	else: for i in filled_poses: split_text[pos][i] = filled_poses[i]
	text = "\n".join(split_text)

## Рисует вертикальную линию из [member ver_line_car] на строке pos. Если сталкивается с
## [member hor_line_car] и [param ignore_crosses] равен [code]false[/code],
## то заменяется на [member cross_line_char]. [b]СИЛЬНО дороже в исполнеии чем draw_hor_line()[/b].
func draw_ver_line(pos:int,ignore_crosses:bool=false,replace_char:bool=true,c_char:String="") -> void:
	pos -= 1
	if c_char == "":
		c_char = ver_line_car
	
	var filled_poses:Dictionary[int,String]={}
	
	#созадние вертикольной сроки
	var split_text:PackedStringArray = []
	var temp_split_text := text.split("\n")
	if temp_split_text[temp_split_text.size()-1] == "\n" or \
	temp_split_text[temp_split_text.size()-1] == "": 
		temp_split_text.remove_at(temp_split_text.size()-1)
	#temp_split_text = ["‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒","‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒","‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒","‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒","‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒","‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒","‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒","‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒","‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒","‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒‒"]
	for line in temp_split_text.size():
		if !replace_char and temp_split_text[line][pos] != empty_char: filled_poses[line] = temp_split_text[line][pos]
		split_text.append(temp_split_text[line][pos])
	
	#редактирование вертикольной сроки
	temp_split_text.clear()
	for car in split_text:
		if car != hor_line_car or ignore_crosses: car = c_char
		if !ignore_crosses: temp_split_text.append(car.replace(hor_line_car, cross_line_char))
		else:temp_split_text.append(car)
	split_text = temp_split_text
	
	#вставка вертикольной сроки
	temp_split_text = text.split("\n")
	if temp_split_text[temp_split_text.size()-1] == "\n" or \
	temp_split_text[temp_split_text.size()-1] == "": temp_split_text.remove_at(temp_split_text.size()-1)
	for i in range(split_text.size()):
		temp_split_text[i][pos] = split_text[i]
	if !replace_char:
		for i in filled_poses:
			temp_split_text[i][pos] = filled_poses[i]
	text = "\n".join(temp_split_text)

## Рисует часть вертикальной линии. См. [method draw_ver_line].
func draw_ver_line_segment(pos:int, from:int, to:int, ignore_crosses:bool=false, c_char:String="") -> void:
	if from > to: push_warning("Can't draw segment if from > to!"); return
	pos -= 1
	if c_char == "":
		c_char = ver_line_car
	
	#созадние вертикольной сроки
	var split_text:PackedStringArray = []
	var temp_split_text := text.split("\n")
	if temp_split_text[temp_split_text.size()-1] == "\n" or \
	temp_split_text[temp_split_text.size()-1] == "": temp_split_text.remove_at(temp_split_text.size()-1)
	for i in temp_split_text.size():
		if i >= from and i <= to:
			if pos > temp_split_text[i].length()-1: break
			split_text.append(temp_split_text[i][pos])
	
	#редактирование вертикольной сроки
	temp_split_text.clear()
	for car in split_text:
		if car != hor_line_car or ignore_crosses: car = c_char
		if !ignore_crosses: temp_split_text.append(car.replace(hor_line_car, cross_line_char))
		else:temp_split_text.append(car)
	split_text = temp_split_text
	
	#вставка вертикольной сроки
	temp_split_text = text.split("\n")
	if temp_split_text[temp_split_text.size()-1] == "\n" or \
	temp_split_text[temp_split_text.size()-1] == "": temp_split_text.remove_at(temp_split_text.size()-1)
	for i in range(split_text.size()):
		temp_split_text[i+from][pos] = split_text[i]
	text = "\n".join(temp_split_text)

## Рисует скрол бар с оффтетом от правого края в [param offset].
func draw_scroll_bar(offset:int=1,ver_offset:int=0,c_char:String="") -> void:
	if line_size.y < 4 or scroll_max == 0: return
	
	if c_char == "":
		c_char = ver_line_car
	
	#созадние вертикольной сроки
	var split_text:PackedStringArray = []
	var temp_split_text := text.split("\n")
	if temp_split_text[temp_split_text.size()-1] == "\n" or \
	temp_split_text[temp_split_text.size()-1] == "": temp_split_text.remove_at(temp_split_text.size()-1)
	for line_n in range(temp_split_text.size()-ver_offset):
		if line_n != ver_offset-1 and line_n != line_size.y:
			split_text.append(temp_split_text[line_n][line_size.x-offset-1])
	
	#редактирование вертикольной сроки
	temp_split_text.clear()
	for car in split_text:
		temp_split_text.append(c_char)
	temp_split_text[0] = up_arrow_char
	temp_split_text[-1] = down_arrow_char
	temp_split_text[floori((temp_split_text.size()-3)*(float(scroll_progress)/float(scroll_max)))+1] = point_char
	split_text = temp_split_text
	
	#вставка вертикольной сроки
	temp_split_text = text.split("\n")
	if temp_split_text[temp_split_text.size()-1] == "\n" or \
	temp_split_text[temp_split_text.size()-1] == "": temp_split_text.remove_at(temp_split_text.size()-1)
	for i in range(split_text.size()):
			temp_split_text[i][line_size.x-offset-1] = split_text[i]
	text = "\n".join(temp_split_text)

## Рисует прямоугольник с началом в [param from] и концом в [param to]+[code]1[/code].
func draw_line_cube(from:Vector2i,to:Vector2i,is_pos_global:bool=false) -> void:
	if !is_pos_global:
		from.y = max(from.y-scroll_progress,0)
		to.y = max(to.y-scroll_progress,0)
	
	var split_text = text.split("\n")
	#print(split_text.size())
	for lines in range(split_text.size()):
		if from.x > split_text[lines].length()-1: break
		if lines == from.y:
			split_text[lines][from.x] = get_char(0b0101)
			for length in range(max(to.x-from.x,0)-1):
				split_text[lines][from.x+length+1] = hor_line_car
			split_text[lines][to.x] = get_char(0b0110)
		elif lines > from.y and lines < to.y:
			split_text[lines][from.x] = ver_line_car
			split_text[lines][to.x] = ver_line_car
		elif lines == to.y:
			split_text[lines][from.x] = get_char(0b1001)
			for length in range(max(to.x-from.x,0)-1):
				split_text[lines][from.x+length+1] = hor_line_car
			split_text[lines][to.x] = get_char(0b1010)
	text = "\n".join(split_text)

## Специальная версия [method draw_line_cube] для рисорания контура.
func draw_border() -> void:
	draw_line_cube(Vector2i(0,0),Vector2i(line_size.x-1,line_size.y-1),true)

## Пичатает текст на позиции pos. [param is_blocked] решает будет ли текст заканчиватся при столкновении
## с любым не [member empty_char] символом. [b]Следует исполнять ПОСЛЕ остальных [method MonitorCL.draw_*][/b].
func draw_text(string:String,pos:Vector2i,is_blocked:bool=true,is_pos_global:bool=false) -> String:
	pos += Vector2i.ONE
	if !is_pos_global:
		if pos.x-scroll_progress < 0: return "" # завершает	 функцию если позиция за экраном
		pos.x = max(pos.x-scroll_progress,0)
	var new_lines:int = 0
	var split_text := text.split("\n")
	var writed_text:String = ""
	if pos.x > split_text.size()-1: return "" # завершает функцию если позиция за экраном
	for i in string.length():
		if pos.x > split_text.size()-1: return "" # завершает функцию если позиция за экраном
		if i+1 < split_text[pos.x+new_lines].length():
			if pos.y+i > split_text[pos.x].length()-1: break # 
			if split_text[pos.x][pos.y+i] != empty_char:
				if is_blocked: break
			if string[i] == "\\" and string[i+1] == "n":
				new_lines += 1; i += 2
			else:
				split_text[pos.x+new_lines][pos.y+i] = string[i]
				writed_text += string[i]
	#await get_tree().create_timer(0.1).timeout
	text = "\n".join(split_text)
	return writed_text

##Специальная версия [method draw_text] для рисования 1 символа (попытки нарисовать больше 1 символа будут проигнорированы). См. [method draw_text].
func draw_uichar(pos:Vector2i,string:String,is_blocked:bool=false,is_pos_global:bool=false) -> String:
	if string.length() > 1: push_warning("draw_uichar trying draw more than 1 character!"); return "" # завершает функцию если string слишком длинная
	pos += Vector2i.ONE
	if !is_pos_global:
		if pos.x-scroll_progress < 0: return "" # завершает функцию если позиция за экраном
		pos.x = max(pos.x-scroll_progress,0)
	var split_text := text.split("\n")
	var writed_text:String = ""
	
	if pos.x > split_text.size()-1: return "" # завершает функцию если позиция за экраном
	if pos.y > split_text[pos.x].length()-1: return "" # завершает функцию если позиция за экраном
	if split_text[pos.x][pos.y] != empty_char and is_blocked: return "" # завершает функцию если на пути не пустой символ и текст блокируемый.
	
	split_text[pos.x][pos.y] = string
	text = "\n".join(split_text)
	
	return writed_text

## Исправляет все [member cross_line_char] заменяя их на правильные угловые символы.
func fix_broken_corners() -> void:
	#var code = 0b0000
	var fixed_text := text.split("\n")
	#первая строка
	var last_line:int = -1 if fixed_text[-1] != "" else -2
	if fixed_text[0][0] == cross_line_char: fixed_text[0][0] = get_char(0b0110)
	if fixed_text[0][-1] == cross_line_char: fixed_text[0][0] = get_char(0b0101)
	for car in line_size.x-2:
		if fixed_text[0][car+1] == cross_line_char: fixed_text[0][car+1] = get_char(0b0111)
	#последняя строка
	if fixed_text[last_line][0] == cross_line_char: fixed_text[0][0] = get_char(0b1010)
	if fixed_text[last_line][-1] == cross_line_char: fixed_text[0][0] = get_char(0b1001)
	for car in line_size.x-2:
		if fixed_text[last_line][car+1] == cross_line_char: fixed_text[last_line][car+1] = get_char(0b1011)
	#остальные
	for line in line_size.y-2:
		if fixed_text[line+1][0] == cross_line_char: fixed_text[0][0] = get_char(0b1110)
		if fixed_text[line+1][-1] == cross_line_char: fixed_text[0][0] = get_char(0b1101)
			
	text = "\n".join(fixed_text)
#endregion

func _on_resized() -> void:
	if Engine.is_editor_hint(): if last_size != size: editor_draw_ui()
	if ignore_tick >= 10:
		ignore_tick = 0
		line_size = calculate_size()
		fill_with()
		if !Engine.is_editor_hint():
			draw_ui()
		last_size = size
	else: ignore_tick += 1

func _on_gui_input(event: InputEvent) -> void:
	#print(event)
	if !is_scrollable: return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scroll_progress = clamp(scroll_progress-1, 0, scroll_max)
			draw_ui()
		elif event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scroll_progress = clamp(scroll_progress+1, 0, scroll_max)
			draw_ui()
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_UP:
			scroll_progress = clamp(scroll_progress-1, 0, scroll_max)
			draw_ui()
		elif event.pressed and event.keycode == KEY_DOWN:
			scroll_progress = clamp(scroll_progress+1, 0, scroll_max)
			draw_ui()
