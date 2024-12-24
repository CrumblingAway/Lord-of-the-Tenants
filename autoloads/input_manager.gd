extends Node

########## Fields. ##########

enum Mode
{
	MENU,
	LEVEL_IDLE,
	LEVEL_PLACING_TENANT,
	LEVEL_SELECTING_TILES,
	LEVEL_MENU,
	COUNT,
}
var _mode : Mode = Mode.COUNT:
	set(mode):
		_mode = mode
		Utils.printdbg("Input mode: %s" % mode_to_string(_mode))
var _previous_mode : Mode = Mode.COUNT
func mode_to_string(mode: Mode) -> String:
	match mode:
		Mode.MENU:
			return "MENU"
		Mode.LEVEL_IDLE:
			return "LEVEL_IDLE"
		Mode.LEVEL_PLACING_TENANT:
			return "LEVEL_PLACING_TENANT"
		Mode.LEVEL_SELECTING_TILES:
			return "LEVEL_SELECTING_TILES"
		Mode.LEVEL_MENU:
			return "LEVEL_MENU"
		_:
			pass
	
	return "Invalid mode."

var _building_floor : BuildingFloor

########## InputManager methods. ##########

func _process_level_input() -> bool:
	if not _building_floor:
		return false
	
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	match _mode:
		Mode.LEVEL_IDLE:
			_building_floor.highlight_apartment_at_global_position(mouse_position)
			if Input.is_action_just_pressed("left_click"):
				if _building_floor.get_apartment_at_global_position(mouse_position):
					_building_floor.highlight_adjacent_apartments_to_hovered()
					_mode = Mode.LEVEL_PLACING_TENANT
			elif Input.is_action_just_pressed("right_click"):
				_building_floor.remove_apartment_at_global_position(mouse_position)
			elif Input.is_action_just_pressed("middle_click"):
				_mode = Mode.LEVEL_SELECTING_TILES
			elif Input.is_action_just_pressed("escape"):
				_previous_mode = _mode
				_mode = Mode.LEVEL_MENU
		Mode.LEVEL_PLACING_TENANT:
			if Input.is_action_just_pressed("left_click"):
				# TODO: Place tenant.
				
				_building_floor.unhighlight_adjacent_apartments_to_hovered()
				_mode = Mode.LEVEL_IDLE
			elif Input.is_action_just_pressed("right_click"):
				# TODO: Remove tenant.
				pass
			elif Input.is_action_just_pressed("escape"):
				_previous_mode = _mode
				_mode = Mode.LEVEL_MENU
		Mode.LEVEL_SELECTING_TILES:
			_building_floor.highlight_reserved_tiles()
			# Reserve/Unreserve tiles.
			if Input.is_action_just_pressed("left_click"):
				if _building_floor.is_tile_at_global_position_available(mouse_position):
					_building_floor.reserve_tile_at_global_position(mouse_position)
				elif _building_floor.is_tile_at_global_position_reserved(mouse_position):
					_building_floor.unreserve_tile_at_global_position(mouse_position)
			# Register reserved tiles.
			elif Input.is_action_just_pressed("right_click"):
				_building_floor.register_reserved_tiles_as_apartment()
			elif Input.is_action_just_pressed("middle_click"):
				_building_floor.unreserve_all_tiles()
				_mode = Mode.LEVEL_IDLE
			elif Input.is_action_just_pressed("escape"):
				_previous_mode = _mode
				_mode = Mode.LEVEL_MENU
		Mode.LEVEL_MENU:
			if Input.is_action_just_pressed("escape"):
				_mode = _previous_mode
				_previous_mode = Mode.LEVEL_MENU
		_:
			pass
	
	return true

########## Node methods. ##########

func _ready() -> void:
	Utils.printdbg("Input mode: %s" % mode_to_string(_mode))

func _process(_delta: float) -> void:
	match _mode:
		Mode.MENU:
			pass
		Mode.LEVEL_IDLE:
			_process_level_input()
		Mode.LEVEL_PLACING_TENANT:
			_process_level_input()
		Mode.LEVEL_SELECTING_TILES:
			_process_level_input()
		Mode.LEVEL_MENU:
			_process_level_input()
		_:
			pass
