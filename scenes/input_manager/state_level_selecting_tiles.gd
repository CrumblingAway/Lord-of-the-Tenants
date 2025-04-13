class_name StateLevelSelectingTiles extends State

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor
var _apt_creation_button : Button

########## StateLevelIdle methods. ##########

func init(level: Level) -> StateLevelSelectingTiles:
	_building_floor = level.building_floors[-1]
	
	_apt_creation_button = level.ui_layer.apt_creation_button
	
	return self

########## State methods. ##########

func enter() -> void:
	_apt_creation_button.text = "Exit apartment creation"
	_apt_creation_button.pressed.connect(_on_apt_creation_button_pressed)

func exit() -> void:
	pass

func process() -> void:
	var mouse_position : Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	
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

func _on_apt_creation_button_pressed() -> void:
	_building_floor.unhighlight_adjacent_apartments_to_hovered()
	_apt_creation_button.pressed.disconnect(_on_apt_creation_button_pressed)
	transition_to.emit("state_level_idle")
