class_name StateLevelSelectingTiles extends State

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor

var _transition_to_apt_creation_button : Button
var _apt_creation_button : Button
var _clear_selected_tiles_button : Button

########## StateLevelIdle methods. ##########

func init(level: Level) -> StateLevelSelectingTiles:
	_building_floor = level.building_floors[-1]
	
	_transition_to_apt_creation_button = level.ui_layer.transition_to_apt_creation_button
	
	_apt_creation_button = level.ui_layer.apt_creation_button
	_apt_creation_button.pressed.connect(_on_apt_creation_button_pressed)
	
	_clear_selected_tiles_button = level.ui_layer.clear_selected_tiles_button
	_clear_selected_tiles_button.pressed.connect(_on_clear_selected_tiles_button_pressed)
	
	return self

########## State methods. ##########

func enter() -> void:
	_transition_to_apt_creation_button.text = "Exit apartment creation"
	_transition_to_apt_creation_button.pressed.connect(_on_transition_to_apt_creation_button_pressed)
	
	_apt_creation_button.visible = true
	_clear_selected_tiles_button.visible = true

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

func _on_transition_to_apt_creation_button_pressed() -> void:
	_building_floor.unhighlight_adjacent_apartments_to_hovered()
	_transition_to_apt_creation_button.pressed.disconnect(_on_transition_to_apt_creation_button_pressed)
	transition_to.emit("state_level_idle")

func _on_apt_creation_button_pressed() -> void:
	_building_floor.register_reserved_tiles_as_apartment()

func _on_clear_selected_tiles_button_pressed() -> void:
	_building_floor.unreserve_all_tiles()
