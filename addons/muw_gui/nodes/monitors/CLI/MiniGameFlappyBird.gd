@tool
extends MiniGameMonitorCLI
##флепи бёрд... (мне надо было на чём то проверить существующую систему)
class_name MiniGameFlappyBird

##позиция "птицы"
var bird_position:float = 0
##позиция "птицы" после конвертирования в текстовый размер
var final_position:int = 0
##имульс вверх
var up_velocity:float = 0.0
##имульс вниз
var down_velocity:float = 0.0
##скорость
var velocity:float = 0.0
##символ "птицы"
var player_char:String = "Ф"
##тут я уже сам хз
var current_pipe_pos:int = 0
##тут я уже сам хз
var offset_pipe_pos:int = 0
## если is_paused == ture: игра не обрабытывает себя
var is_paused:bool = true
## Лист туб. Трубы представдены словлрём с ключами: "pos" - растояние от начала,
## "up_seg" - дилна верхней трубы, "dw_seg" - дилна нижней трубы.
var pipes:Array[Dictionary] = []

## Кол-во тиков для обновления труб. (проще скорость)
var pipe_speed:int = 20
## Кол-во прощедщих тиков
var pipe_progress:int = 0

## Кол-во тиков нахождения в трубе после коттороо игрок умирает.
var deaf_time:int = 3
## Кол-во прощедщих тиков
var deaf_timer:int = 0

func _ready() -> void:
	draw_ui_on_ready = false
	super()
	
	pipes.append({"pos":12,"up_seg":1,"dw_seg":4})
	for i in 9:
		pipes.append(get_new_pipe())

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or is_paused: return
	
	up_velocity = move_toward(up_velocity, 0, 0.05)
	down_velocity = move_toward(down_velocity, 2, max(down_velocity*0.03,0.01)) if !on_floor() else 0
	velocity = (up_velocity - down_velocity)*0.1
	
	bird_position = clamp(bird_position+velocity,0,line_size.y-3)
	final_position = -floori(bird_position) + line_size.y-3
	
	pipe_progress += 1
	var remove_pipes := []
	if pipe_progress > pipe_speed:
		pipe_progress = 0
		offset_pipe_pos -= 1
		
		for i in pipes.size(): 
			if pipes[i]["pos"]+offset_pipe_pos <= 1: remove_pipes.append(i)
		remove_pipes.reverse()
		if remove_pipes.size() >0: print("remove at: ",remove_pipes)
		for i in remove_pipes:
			pipes.remove_at(i)
			pipes.append(get_new_pipe())
			pipe_speed = max(pipe_speed-1,1)
	
	if velocity > 0: player_char = "П"
	elif velocity == 0: player_char = "_"
	else: player_char = "Ш"
	
	draw_ui()
	
	if get_char_from_text(Vector2i(final_position+1,1)) == ver_line_car or \
	   get_char_from_text(Vector2i(final_position+1,1)) == get_char(0b1011) or \
	   get_char_from_text(Vector2i(final_position+1,1)) == get_char(0b0111):
		#set_char_from_text(Vector2i(final_position+1,1),"А")
		if deaf_timer > deaf_time: deaf_timer=0; reset()
		else: deaf_timer += 1
	else: deaf_timer = 0

func get_new_pipe() -> Dictionary[String,int]:
	var new_pipe:Dictionary[String,int] = {"pos":0,"up_seg":0,"dw_seg":0}
	var gap:int = randi_range(4,7)
	new_pipe["pos"] = pipes[-1]["pos"]+randi_range(6,15)
	new_pipe["up_seg"] = randi_range(1, clamp(line_size.x-1 -gap, 1, 6) )#randi_range(1,4)#clamp(pipes[-1]["up_seg"]+randi_range(-1,2),1,max(pipes[-1]["dw_seg"]-1,0))
	new_pipe["dw_seg"] = randi_range(2, clamp(9-gap-new_pipe["up_seg"], 2, 7) )#randi_range(2,4)#clamp(pipes[-1]["dw_seg"]+randi_range(-1,2),1,max(new_pipe["up_seg"]-1,0))
	print("Gotten new pipe: "+str(new_pipe))
	return new_pipe

func reset() -> void:
	pipe_speed = 20
	offset_pipe_pos = 0
	pipes = [{"pos":12,"up_seg":1,"dw_seg":4}]
	for i in 9:
		pipes.append(get_new_pipe())

func on_floor() -> bool:
	return final_position >= line_size.y-3

func _on_gui_input(event: InputEvent) -> void:
	#super(event)
	if is_paused: return
	if event is InputEventMouseButton:
		if event.pressed and \
		(event.button_index == MOUSE_BUTTON_LEFT or \
		 event.button_index == MOUSE_BUTTON_RIGHT):
			up_velocity = 2
			down_velocity = 0
			bird_position = floor(bird_position)

func draw_pipe(pos:int,up_length:int,down_length:int):
	draw_ver_line_segment(pos, 1, up_length+1)
	draw_ver_line_segment(pos, line_size.y-down_length, line_size.y-2)
	draw_uichar(Vector2i(up_length+1,pos-2),get_char(0b1011))
	draw_uichar(Vector2i(line_size.y-down_length-1,pos-2),get_char(0b0111))

func draw_ui() -> void:
	fill_with()
	draw_core_ui()
	
	draw_text("Оч0"+
			" Ск"+str(pipe_speed)+
			" Пк"+str(final_position)+
			" Рз"+str(line_size.y)+
			#" Рр"+str(line_size.y-3)+
			" Пр"+str(str(snapped(bird_position,0.01))), Vector2i(-1,1), false)
	
	for pipe in pipes:
		draw_pipe(pipe["pos"]+offset_pipe_pos, pipe["up_seg"], pipe["dw_seg"])
	draw_uichar(Vector2i(final_position,1), player_char, false)

func _validate_property(property: Dictionary) -> void:
	var n = property.name
	if n == "is_scrollable" or \
		n == "scroll_max" or \
		n == "scroll_progress" or \
		n == "scroll_bar_offset" or \
		n == "Scroling":
			property.usage |= PROPERTY_USAGE_NO_EDITOR

func _on_wire_input_changed(input:Array[Variant]):
	pass
