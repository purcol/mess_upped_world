extends Resource
## Ресурс проводов
class_name WireResoure

## ID провода
@export var id:StringName = &""

# информация о точке
## оффест от начала стороны. См. [param Mode].
@export var offset:float = 0.0 #:
	#set(val):
		#offset = max(0,val) if Mode == GU.POS_MODE.FIXED else clampf(0,1,val)
## Режим оффсета. GU.POS_MODE.PROCENT - офсет от 0 до 1, где 0 это начало, а 1 это конец стороны.
## GU.POS_MODE.FIXED - растояние от начала стороны.
@export var Mode:GU.POS_MODE = GU.POS_MODE.PROCENT
## Сторона на которой находится точка подключения
@export var Side:GU.SIDE = GU.SIDE.UP

# о нодах провода
## путь до ноды точки подключения с этим ресурсом от корня сцены.
var path:NodePath = ""

#быстрый доступ
##глобальная позиция точки
var pos_node:Vector2 = Vector2(0,0)

func _init() -> void:
	var c:int = 0
	
	while true:
		if GU.ids.has( StringName(str((get_path()+str(c)).hash())) ):
			c+=1
		else:
			break
	id = StringName(str((get_path()+str(c)).hash()))
	GU.ids.append(id)
