extends Node

########## Fields. ##########

enum Mode
{
	MENU,
	LEVEL_IDLE,
	LEVEL_PLACING_TENANT,
	LEVEL_SELECTING_TILES,
	COUNT,
}
var _mode : Mode = Mode.COUNT:
	set(mode):
		_mode = mode
		print_mode()
func mode_to_string(mode: Mode) -> String:
	match _mode:
		Mode.MENU:
			return "MENU"
		Mode.LEVEL_IDLE:
			return "LEVEL_IDLE"
		Mode.LEVEL_PLACING_TENANT:
			return "LEVEL_PLACING_TENANT"
		Mode.LEVEL_SELECTING_TILES:
			return "LEVEL_SELECTING_TILES"
		_:
			pass
	
	return "Invalid mode."

var _floor_level : FloorLevel

########## InputManager methods. ##########

func _process_level_input() -> bool:
	if not _floor_level:
		return false
	
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	match _mode:
		Mode.LEVEL_IDLE:
			_floor_level.highlight_apartment_at_global_position(mouse_position)
			if Input.is_action_just_pressed("left_click"):
				if _floor_level.get_apartment_at_global_position(mouse_position):
					_mode = Mode.LEVEL_PLACING_TENANT
			elif Input.is_action_just_pressed("right_click"):
				_floor_level.remove_apartment_at_global_position(mouse_position)
			elif Input.is_action_just_pressed("middle_click"):
				_mode = Mode.LEVEL_SELECTING_TILES
		Mode.LEVEL_PLACING_TENANT:
			_floor_level.highlight_adjacent_apartments_to_hovered()
			if Input.is_action_just_pressed("left_click"):
				_floor_level.unhighlight_adjacent_apartments_to_hovered()
				_mode = Mode.LEVEL_IDLE
		Mode.LEVEL_SELECTING_TILES:
			_floor_level.highlight_reserved_tiles()
			# Reserve/Unreserve tiles.
			if Input.is_action_just_pressed("left_click"):
				if _floor_level.is_tile_at_global_position_available(mouse_position):
					_floor_level.reserve_tile_at_global_position(mouse_position)
				elif _floor_level.is_tile_at_global_position_reserved(mouse_position):
					_floor_level.unreserve_tile_at_global_position(mouse_position)
			# Register reserved tiles.
			elif Input.is_action_just_pressed("right_click"):
				_floor_level.register_reserved_tiles_as_apartment()
			elif Input.is_action_just_pressed("middle_click"):
				_floor_level.unreserve_all_tiles()
				_mode = Mode.LEVEL_IDLE
		_:
			pass
	
	return true

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
		Mode.LEVEL_PLACING_TENANT:
			_process_level_input()
		Mode.LEVEL_SELECTING_TILES:
			_process_level_input()
		_:
			pass
