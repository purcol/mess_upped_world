extends Resource
class_name ItemResource

@export var name:StringName = ""
@export var ru_name:StringName = ""
@export_multiline("monospace", "no_wrap") var desc:String = ""
@export_multiline("monospace", "no_wrap") var ru_desc:String = ""
var words_with_effects:Dictionary[int,Array] = {}
# BBC CODES: BOSS=0,DIFFICULTY=1,MOVEMENT=2,NODE=3,WARNING=4,WEAPON=5

## возвращает все сроки на которых должен быть эффект [param effect].
## [GU.current_lang] решает на коком языке будет вывод. (См. GU.LANG)
func _get_words_with_effects(effect:GU.BBC_CODES) -> Array[String]:
	#print("ef:",effect, " format:", "[{0}]".format([effect]))
	var s_desc:String = desc if GU.current_lang == GU.LANG.EN else ru_desc
	var bbc_pos:Array[int] = []
	var return_list:Array[String] = []
	var length:int
	if "[{0}]".format([effect]) in s_desc:
		for i in s_desc.length():
			if "[{0}]".format([effect]) not in s_desc.substr(i) or s_desc.count("[{0}]".format([effect]))<=return_list.size(): return return_list
			bbc_pos = [s_desc.find("[{0}]".format([effect]),i)+3,s_desc.find("[/{0}]".format([effect]),i)]
			length = bbc_pos[1]-bbc_pos[0]
			return_list.append(s_desc.substr(bbc_pos[0],length))
			i = min(i+length+bbc_pos[0], s_desc.length())
			#print("i:", i," pos:",bbc_pos," chars:",s_desc[bbc_pos[0]],s_desc[bbc_pos[1]],s_desc[i+length]," len:",length, " ret:", return_list[-1])
	else: return_list = []
	
	return return_list

## возвращает строки описания ввиде списка с длиной строк не больше [param line_lengh].
## [GU.current_lang] решает на коком языке будет вывод. (См. GU.LANG)
func get_desc_lines(line_lengh:int) -> Array[String]:
	var s_desc:String = desc if GU.current_lang == GU.LANG.EN else ru_desc
	for i in GU.BBC_CODES.size(): s_desc = s_desc.replace( "["+str(i)+"]", "" ).replace( "[/{0}]".format([i]), "" ).replace("\n", " ")
	var return_list:Array[String] = []
	for i in range(0,s_desc.length(),line_lengh):
		return_list.append(s_desc.substr(i,i+line_lengh))
	return return_list

func _fix_desc_lines(broken_desc:Array[String],line_lengh:int) -> Array[String]:
	var return_list:Array[String] = []
	var string:String = ""
	for i in broken_desc.size():
		string = broken_desc[i]
		if string.length() > line_lengh:
			for separator in [" ",",",".",":"]:
				if separator in string:
					print("FIX ",string.split(separator)[-1])
	return broken_desc

## возвращает название ресурса на основе [param lang]. (См. GU.LANG)
func get_title() -> StringName:
	return name if GU.current_lang == GU.LANG.EN else ru_name

## возвращает описание ресурса на основе [param lang]. (См. GU.LANG)
func get_desc(lang:GU.LANG=GU.LANG.EN) -> StringName:
	return desc if lang == GU.LANG.EN else ru_desc

func generate_word_effects() -> void:
	for code in GU.BBC_CODES.values():
		words_with_effects[code] = _get_words_with_effects(code)
	#print("\n",GU.BBC_CODES)
	#print(words_with_effects)
