class_name StateLevelSelectingTiles extends State

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor

########## StateLevelIdle methods. ##########

func init(level: Level) -> StateLevelSelectingTiles:
	_building_floor = level.building_floors[-1]
	
	return self

########## State methods. ##########

func enter() -> void:
	pass

func exit() -> void:
	pass

func process() -> void:
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	_building_floor.highlight_reserved_tiles()
	if Input.is_action_just_pressed("left_click"):
		if _building_floor.is_tile_at_global_position_available(mouse_position):
			_building_floor.reserve_tile_at_global_position(mouse_position)
		elif _building_floor.is_tile_at_global_position_reserved(mouse_position):
			_building_floor.unreserve_tile_at_global_position(mouse_position)
	elif Input.is_action_just_pressed("right_click"):
		_building_floor.register_reserved_tiles_as_apartment()
	elif Input.is_action_just_pressed("middle_click"):
		_building_floor.unreserve_all_tiles()
		transition_to.emit("state_level_idle")
