extends BaseButton
class_name HoverButton
## Кнопка которая, при нажатии на неё или наведение, задаёт [param GlobalGUIScript.last_hovered]

## при значечнии [code]true[\code] идёт выбор точки подключения.
var is_prew_wire:bool = false

## Сингал издаётся при попытке подключить точки.
signal aply_points_conection(path:NodePath)

func _ready() -> void:
	var area:HoverButtonArea = HoverButtonArea.new()
	area.z_index = 98;
	add_child(area)

func _toggled(toggled_on: bool) -> void:
	if toggled_on and GU.is_bizzy: return
	is_prew_wire = toggled_on
	GU.is_bizzy = toggled_on 
	if !toggled_on: aply_points_conection.emit(GU.last_hovered)

func _process(_delta: float) -> void:
	#if !(is_prew_wire and Input.is_action_pressed("ConfirmGUI")): is_prew_wire = false
	if is_hovered() and !is_prew_wire: hover()

## Подключается к [signal mouse_shape_entered]. Задаёт [param GlobalGUIScript.last_hovered].
func hover() -> void:
	GU.last_hovered = $"../".get_path()
	#print(GU.last_hovered)
