extends Node

##ID оружий
enum WEAPONS {
	SHOTER = 0,
	CHARGER_SHOTER = 1,
	SHOTERS_SHOTER = 2,
	LAZER = 3,
	LAZER_MINE = 4,
	WAVE = 4
}
##название оружия: [имя, путь к оружию, активное?]
var weapon_info:Dictionary[int,Array] = {
	0:["shoter","res://components/weapons_shoters/shoter_c.tscn",false],
	1:["charged_shoter","res://components/weapons_shoters/charged_shoter_c.tscn",true],
	2:["shoters_shoter","res://components/weapons_shoters/shoters_shoter_c.tscn",false],
	3:["lazer","res://components/weapons_shoters/lazer_shoter_c.tscn",true],
	4:["lazer_mine","res://components/weapons_shoters/lazer_mine_shoter_c.tscn",false],
	5:["wave","res://components/weapons_shoters/wave_shoter_c.tscn",false]
}

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

##возращает true, если оружие активное, иначе false.
func is_active(weapon_id:int) -> bool:
	return weapon_info.get(weapon_id)[2]

func is_equiped(weapon_id:int) -> bool:
	return selected_weapons.has(weapon_info.get(weapon_id)[0])

##возращает true, если можно экипировать пасиввное оружие, иначе false.
func can_equip_passive_weapon() -> bool:
	return selected_restricted_weapons.get("active") != ""

##экипировать оружие. Если надеть оружие удалось возвращает ture, иначе false.
func equip_weapon(weapon_id:int) -> bool:
	var is_pasive:bool = !is_active(weapon_id)
	if is_pasive:
		if can_equip_passive_weapon():
			selected_weapons.append(weapon_info.get(weapon_id)[0])
			selected_restricted_weapons.set("passive",weapon_info.get(weapon_id)[0])
			GDebug.print_log("WeaponInteractions",[weapon_info.get(weapon_id)[0]+" has bean equip."])
			return true
	else:
		selected_weapons.append(weapon_info.get(weapon_id)[0])
		selected_restricted_weapons.set("active",weapon_info.get(weapon_id)[0])
		GDebug.print_log("WeaponInteractions",[weapon_info.get(weapon_id)[0]+" has bean equip."])
		return true
	return false

##снять оружие. Если снять оружие удалось возвращает ture, иначе false.
func unequip_weapon(weapon_id:int):
	if is_equiped(weapon_id):
		selected_weapons.erase(weapon_info.get(weapon_id)[0])
		var is_pasive:bool = !is_active(weapon_id)
		if is_pasive: selected_restricted_weapons.set("passive", "")
		else: selected_restricted_weapons.set("active", "")

##снять оружие если надето, надеть если снято.
func toggle_weapon(weapon_id:int):
	if is_equiped(weapon_id): unequip_weapon(weapon_id)
	else: equip_weapon(weapon_id)

func _process(_delta: float) -> void:
	#если нет активного оружия, то убрать пасивное
	if selected_restricted_weapons["active"] == "":
		selected_restricted_weapons["passive"] = ""
	for i in selected_weapons:
		if selected_restricted_weapons.find_key(i) == null:
			selected_weapons.erase(i)
			GDebug.print_log("WeaponInteractions",[i+" was erased from selected_weapons"])
