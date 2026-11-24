@tool
extends Node
class_name GlobalGUIScript

enum POS_MODE {PROCENT=0,FIXED=1}
enum SIDE {UP=0,DOWN=2,LEFT=3,RIGHT=1}
enum ALL_SIDES { ALL=0b1111, NONE=0b0000,
	#одна сторона
	UP=0b1000,DOWN=0b0100,LEFT=0b0010,RIGHT=0b0001, 
	
	#две стороны
	UP_DOWN=0b1100, UP_LEFT=0b1010, UP_RIGHT=0b1001,
	DOWN_LEFT=0b0110,DOWN_RIGHT=0b0101,LEFT_RIGHT=0b0011,
	
	#три стороны
	UP_DOWN_LEFT=0b1110,UP_DOWN_RIGHT=0b1101,
	LEFT_RIGHT_UP=0b1011,LEFT_RIGHT_DOWN=0b0111
	}
## Enum со кодов эффектов. 
enum BBC_CODES {BOSS=0,DIFFICULTY=1,MOVEMENT=2,NODE=3,WARNING=4,WEAPON=5}
## Enum языков
enum LANG {EN=0,RU=1}
## текущий язык.
var current_lang = LANG.EN
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
var names:Dictionary[String,Dictionary]= {
	"weapon_type":{GU.LANG.RU:"Вид Оружия:", GU.LANG.EN:"Weapon Type:"},
	"active":{GU.LANG.RU:"Активные", GU.LANG.EN:"Active"},
	"passive":{GU.LANG.RU:"Пасивные", GU.LANG.EN:"Passive"}
}
## получить строку из [names] с ключом [param key] основываясь на языке.
func get_str(key:String):
	return names[key][GU.current_lang]

const wire_in_end_texture := preload("res://addons/muw_gui/textures/wire_in_end.png")
const wire_out_end_texture := preload("res://addons/muw_gui/textures/wire_out_end.png")
const monitor_texture := preload("res://addons/muw_gui/textures/monitor_texture.png")
const button_theme := preload("res://addons/muw_gui/resources/themes/monitor_button.tres")
const borderless_button_theme := preload("res://addons/muw_gui/resources/themes/monitor_button_no_border.tres")
const EMPTY_CONTENT = {"NONE":[]}

## все существующие id
var ids:Array[StringName] = [&""]

var last_hovered:NodePath = ""
var is_bizzy = false
