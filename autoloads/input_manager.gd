extends Node

enum Mode
{
	MENU,
	LEVEL,
	COUNT,
}

########## Fields. ##########

var _mode : Mode = Mode.COUNT

var _floor_level : FloorLevel

########## InputManager methods. ##########

func _process_level_input() -> bool:
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	if _floor_level:
		_floor_level.highlight_apartment_at_global_position(mouse_position)
	
	return true

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match _mode:
		Mode.MENU:
			pass
		Mode.LEVEL:
			_process_level_input()
		_:
			pass
