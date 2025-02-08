class_name StateLevelIdle extends State

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor

########## StateLevelIdle methods. ##########

func init(level: Level) -> StateLevelIdle:
	_building_floor = level.building_floors[-1]
	
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
		if _building_floor.get_apartment_at_global_position(mouse_position):
			Utils.printdbg(
				"Output noise: %d, Input noise: %s",
				func(): 
					var apartment : Apartment = _building_floor.get_apartment_at_global_position(mouse_position)
					var total_noise : int = _building_floor.get_noise_input_in_apartment(apartment)
					return [
						apartment.get_noise_output(),
						"%d/%d" % [total_noise, apartment.get_noise_tolerance()]
					]
			)
			
			_building_floor.highlight_adjacent_apartments_to_hovered()
			transition_to.emit("state_level_placing_tenant")
	elif Input.is_action_just_pressed("right_click"):
		_building_floor.remove_apartment_at_global_position(mouse_position)
	elif Input.is_action_just_pressed("middle_click"):
		transition_to.emit("state_level_selecting_tiles")
