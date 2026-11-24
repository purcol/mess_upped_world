@tool
extends MonitorCLI
## Нода дял предпросмотра описаний и названий ресурсов [ItemResoure].
class_name ItemDescPreview

var item:ItemResource:
	set(val):
		item = val
		draw_ui()

func _ready() -> void:
	super._ready()

func generic_draw_ui() -> void:
	if item == null: return
	fill_with()
	if Engine.is_editor_hint(): draw_text("ИМЯТУТ",Vector2(-1,0))
	elif item != null: draw_text(item.get_title(),Vector2(-1,0))
	draw_hor_line(2)
	draw_ver_line(line_size.x-1,true)
	var desc:Array[String] = item.get_desc_lines(line_size.x-2)
	for i in desc.size():
		draw_text(desc[i],Vector2(1+i,-1))
	scroll_max = max(0,desc.size()+2-(line_size.y))+1
	is_scrollable = scroll_max > 0
	if !is_scrollable:
		set_char_from_text(Vector2i(1,line_size.x-1),empty_char)
	else: draw_scroll_bar(0)

func editor_draw_ui() -> void: generic_draw_ui()
func draw_ui() -> void: generic_draw_ui()

func _on_wire_input_changed(input:Array[Variant]) -> void:
	pass
