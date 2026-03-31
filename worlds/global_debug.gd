extends Node

#region var
@export_category("Debug")
##выключает урон, зум камер 0.5.
@export var dev_mode:bool = false
##словарь содержащий настройки логирования.
## StartupInit - иницализация при запуске игры и сцен вообщем.
## SaveAndLoad - сохранения и загрузки.
## ButtonInit - иницализация/действия/логика кнопок.
## PlayerInit - иницализация игрока.
## EntityInteractions - взаимодействие/дайствия сущностей.
## EntityFrequentInteractions - частые EntityInteractions, по типу смерти пули. 
## WorldActions - процессы мира.
## WeaponInteractions - обработка/процессы оружий и остальной экипировки.
@warning_ignore("shadowed_global_identifier")
@export var log:Dictionary[String,bool] = {
	"StartupInit":false,
	"SaveAndLoad":false,
	"ButtonInit":false,
	"PlayerInit":false,
	"EntityInteractions":false,
	"EntityFrequentInteractions":false,
	"WorldActions":false,
	"WeaponInteractions":false
	}
@export var hide_backround:Dictionary[String,bool] = {"Pease":false,"BattelZone":false}
#endregion

#region log
func print_log(log_type:String,string:Array,masage_type:int=0) -> void:
	if Engine.is_editor_hint(): return
	if log.get(log_type):
		var print_line:String = ""
		var time = Time.get_time_dict_from_system()
		var log_time = str(time.get("hour"))+"."+str(time.get("minute"))+"."+str(time.get("second"))
		for i in string:
			print_line = print_line+str(i)
		match log_type:
			"StartupInit": print_line = "[SI]| " + print_line
			"SaveAndLoad": print_line = "[SL]| " + print_line
			"ButtonInit": print_line = "[BI]| " + print_line
			"PlayerInit": print_line = "[PI]| " + print_line
			"EntityInteractions": print_line = "[EI]| " + print_line
			"EntityFrequentInteractions": print_line = "[Ei]| " + print_line
			"WorldActions": print_line = "[WA]| " + print_line
			"WeaponInteractions": print_line = "[WI]| " + print_line
			_: print_line = "[  ]| " + print_line
		match masage_type:
			1: push_error("ERROR|",log_time,"|",print_line); print_rich("[color=salmon]ERROR|",log_time,"|",print_line)
			2: push_warning("WARNING|",log_time,"|",print_line); print_rich("[color=gold]WARNING|",log_time,"|",print_line)
			_: print("INFO|",log_time,"|",print_line)

func print_error_log(log_type:String,string:Array):
	print_log(log_type,string,1)

func print_warning_log(log_type:String,string:Array):
	print_log(log_type,string,2)
#endregion
