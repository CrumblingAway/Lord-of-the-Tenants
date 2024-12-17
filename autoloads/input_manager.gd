extends Node

########## Fields. ##########

enum Mode
{
	MENU,
	LEVEL_IDLE,
	LEVEL_SELECTING_TILES,
	COUNT,
}
var _mode : Mode = Mode.COUNT:
	set(mode):
		_mode = mode
		print_mode()

var _floor_level : FloorLevel

########## InputManager methods. ##########

func _process_level_input() -> bool:
	if not _floor_level:
		return false
	
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	match _mode:
		Mode.LEVEL_IDLE:
			_floor_level.highlight_apartment_at_global_position(mouse_position)
			if Input.is_action_just_pressed("middle_click"):
				_mode = Mode.LEVEL_SELECTING_TILES
		Mode.LEVEL_SELECTING_TILES:
			_floor_level.highlight_reserved_tiles()
			if Input.is_action_just_pressed("left_click"):
				if _floor_level.is_tile_at_global_position_available(mouse_position):
					_floor_level.reserve_tile_at_global_position(mouse_position)
				elif _floor_level.is_tile_at_global_position_reserved(mouse_position):
					_floor_level.unreserve_tile_at_global_position(mouse_position)
			elif Input.is_action_just_pressed("right_click"):
				_floor_level.register_reserved_tiles_as_apartment()
			elif Input.is_action_just_pressed("middle_click"):
				_mode = Mode.LEVEL_IDLE
		_:
			pass
	
	return true

func mode_to_string(mode: Mode) -> String:
	match _mode:
		Mode.MENU:
			return "Mode.MENU"
		Mode.LEVEL_IDLE:
			return "LevelMode.IDLE"
		Mode.LEVEL_SELECTING_TILES:
			return "LevelMode.SELECTING_TILES"
		_:
			pass
	
	return "Invalid mode."

func print_mode() -> void:
	if OS.is_debug_build():
		print("Input manager mode: %s" % mode_to_string(_mode))

########## Node methods. ##########

func _ready() -> void:
	print_mode()

func _process(delta: float) -> void:
	match _mode:
		Mode.MENU:
			pass
		Mode.LEVEL_IDLE:
			_process_level_input()
		Mode.LEVEL_SELECTING_TILES:
			_process_level_input()
		_:
			pass
