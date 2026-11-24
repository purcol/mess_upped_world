extends WireResoure
class_name WireInResoure
## Ресурс для проводов получающих информацию

# о нодах провода
## путь до ноды точки подключения от корня сцены.
@export var path_to_emitter:NodePath = ""

## Список того что провод получил.
@export var content:Array[Variant] = [] :
	set(val):
		content = val
		content_resived.emit(content)

## Сигнал издаётся при изменении [param content]
signal content_resived(content:Array[Variant])

func conect_signal_to_node(callable:Callable) -> void:
	content_resived.connect(callable)

func disconect_signal_to_node(callable:Callable) -> void:
	content_resived.disconnect(callable)
