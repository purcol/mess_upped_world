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
	s_desc = s_desc.replace("\n", "")
	
	#line_lengh -= 1
	var return_list:Array[String] = []
	var counter:int = 0
	while counter * line_lengh < s_desc.length():
		return_list.push_back( s_desc.substr(counter*line_lengh, line_lengh) )
		counter += 1
	for i in return_list.size():
		while return_list[i][0] == " ": return_list[i] = return_list[i].erase(0)
		#if return_list[i][-1] == " ": return_list[i] = return_list[i].erase(-1)
	return return_list

func exsperemental_get_desc_lines(line_lengh:int) -> Array[String]:
	#подкотовка к обработке описания
	var s_desc:String = desc if GU.current_lang == GU.LANG.EN else ru_desc
	for i in GU.BBC_CODES.size(): s_desc = s_desc.replace( "["+str(i)+"]", "" ).replace( "[/{0}]".format([i]), "" ).replace("\n", " ")
	s_desc = s_desc.replace("\n", " ")
	
	#сырое разделение строк
	var return_list:Array[String] = []
	for i in range(0,s_desc.length(),line_lengh):
		return_list.append(s_desc.substr(i,i+line_lengh))
	
	var counter = 0
	for i in s_desc.length():
		if i+1 <= s_desc.length():
			counter += 1
			@warning_ignore("standalone_expression")
			if s_desc[i]+s_desc[i+1] == "\n": i+1
			else:
				if counter % line_lengh == 0: s_desc = s_desc.insert(i,"\n");
	
	var temp_split:Array = []
	temp_split = Array(s_desc.split("\n"))
	var temp_split_sum:String = ""
	for i in range(1,temp_split.size()):
		temp_split_sum = temp_split[i-1].split(" ")[-1]+temp_split[i].split(" ")[0]
		if temp_split_sum in s_desc.replace("\n",""):
			s_desc = s_desc.replace("\n","").insert(s_desc.find(temp_split_sum), "\t")
		#print(temp_split_sum, "|", temp_split[i-1],"+",temp_split[i])
	s_desc = s_desc.replace("\t","\n")
	#print(s_desc,"\n\n",return_list)
	#print(line_lengh,"\n",s_desc,"\n\n",return_list)
	
	counter = 0
	temp_split = s_desc.split("\n")
	var temp_holder:Array[String] = []
	#for i in temp_split.size(): if temp_split[i].ends_with(" "): temp_split[i].erase(temp_split[i].length()-1)
	for i in temp_split.size():
		if temp_split[i].length() > line_lengh:
			temp_holder.append(temp_split[i])
			temp_split.remove_at(i)
			for j in range(line_lengh,temp_holder[0].length(),line_lengh):
				temp_holder[0].insert(j,"\n")
			print(temp_holder)
			temp_split.insert(i,temp_holder[0])
			
	print(temp_split)
	
	return return_list

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
