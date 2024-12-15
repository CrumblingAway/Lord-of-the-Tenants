extends Node

enum Mode
{
	MENU,
	LEVEL,
	COUNT,
}

########## Fields. ##########

var _current_mode : Mode = Mode.COUNT

########## InputManager methods. ##########

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	match _current_mode:
		Mode.MENU:
			pass
		Mode.LEVEL:
			pass
		_:
			pass
