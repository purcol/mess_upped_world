@icon("res://addons/muw_gui/textures/icons/MonitorCLI.svg")
@tool
@abstract
extends MonitorCL

##@experimental: Класс и особено его методы не стабильны.
## Интерактивная версия [MonitorCL] добовляющая возможность создовать кнопки.
class_name MonitorCLI

## Если ture выполняет [method delete_buttons] перед [method draw_ui]. НЕ ВЫКЛЮЧАТЬ! 
@export var force_button_deletion_on_draw_ui:bool = true

#region gen
## Создаёт [MenuButton] (если [param is_popup] [code]false[/code], то [Button]) с именем [param strirng],
## в позиции [param pos] и там же с таким той же стокой отрисовывает текст.
## [param is_blocked] текста - [code]false[/code]. (См. [method MonitorCL.draw_text])
func create_button(strirng:String,pos:Vector2i,force_length:int=-1,script:Script=null,properties:Dictionary[StringName,Variant]={},is_brl_theme:bool=false,is_text_on_b:bool=false,is_popup:bool=false) -> void:
	if pos.x-scroll_progress < 0: return
	var button:Button = MenuButton.new() if is_popup else Button.new()
	button.name = strirng; button.size = Vector2(
		(strirng.length() if force_length <= 0 else force_length) \
		 * char_size.x, char_size.y)
	button.position = get_local_text_position(pos)
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	if script != null: button.set_script(script)
	button.theme = GU.borderless_button_theme if is_brl_theme else GU.button_theme
	if !is_text_on_b: draw_text(strirng,pos-Vector2i(1,0),false); button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	else: button.text = strirng
	if properties != {}:
		for prop in properties: button.set(prop, properties[prop])
	add_child(button)

## Удаляет всех детей класса [BaseButton].
func delete_buttons(include_internal:bool=true) -> void:
	for node in get_children(include_internal):
		if node is BaseButton: node.queue_free()
#endregion gen

#region drawing
## Функция для груписования [method MonitorCL.draw_*] функций в не редактора.
func draw_ui() -> void:
	if !Engine.is_editor_hint():
		pre_effects(true)
		draw_core_ui()

func pre_effects(calculate_size:bool=false) -> void:
	super.pre_effects(calculate_size)
	if force_button_deletion_on_draw_ui: delete_buttons()
#endregion drawing
