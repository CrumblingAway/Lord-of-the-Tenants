class_name StateLevelIdle extends State

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor

########## StateLevelIdle methods. ##########

func init(other_building_floor: BuildingFloor) -> StateLevelIdle:
	_building_floor = other_building_floor
	
	return self

########## State methods. ##########

func enter() -> void:
	pass

func exit() -> void:
	pass

func process() -> void:
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	_building_floor.highlight_apartment_at_global_position(mouse_position)
	if Input.is_action_just_pressed("left_click"):
		pass
	elif Input.is_action_just_pressed("right_click"):
		pass
	elif Input.is_action_just_pressed("middle_click"):
		transition_to.emit("state_level_selecting_tiles")
