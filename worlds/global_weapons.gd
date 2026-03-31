extends Node

##ограниченный 1 пассивным и 1 активным оружием список выбранных орудий.
var selected_restricted_weapons:Dictionary[String,String] = {
	"active":"",
	"passive":""}
##список выбранных оружий.
var selected_weapons:Array[String] = []
##выбранный вид двежения. Числа брать из MovementType игрока.
var selected_movement:int = 0


func earese_from_restricted(value:String) -> String:
	var key = selected_restricted_weapons.find_key(value)
	if key == null: push_error("Can't earese from null key!"); return ""
	if selected_restricted_weapons[key] != "":
		selected_restricted_weapons[key] = ""
	if selected_weapons.has(value): selected_weapons.erase(value)
	else: push_error("selected_weapons dose not have "+value+" to earese!")
	GDebug.print_log("ButtonInit",[value+" was earesed from restricted weapons with key: "+key])
	#print("INFO| "+value+" was earesed from restricted weapons with key: "+key)
	return key


func _process(_delta: float) -> void:
	#если нет активного оружия, то убрать пасивное
	if selected_restricted_weapons["active"] == "":
		selected_restricted_weapons["passive"] = ""
	for i in selected_weapons:
		if selected_restricted_weapons.find_key(i) == null:
			selected_weapons.erase(i)
			GDebug.print_log("WeaponInteractions",[i+" was erased from selected_weapons"])
