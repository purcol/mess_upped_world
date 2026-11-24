extends WireResoure
## Ресурс для проводов раздающих информацию
class_name WireOutResoure

# о нодах провода
## путь до ноды точки подключения от корня сцены.
@export var path_to_receiver:NodePath = ""
## Список того что провод передаёт.
@export var content:Array[Variant] = [] :
	set(val):
		content = val
		content_emited.emit(content)

signal content_emited(content:Array[Variant])

func conect_signal_to_node(callable:Callable) -> void:
	content_emited.connect(callable)

func disconect_signal_to_node(callable:Callable) -> void:
	content_emited.disconnect(callable)
