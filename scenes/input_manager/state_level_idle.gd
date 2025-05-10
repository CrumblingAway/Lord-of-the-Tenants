class_name StateLevelIdle extends State

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor

var _level : Level

########## StateLevelIdle methods. ##########

func init(level: Level) -> StateLevelIdle:
	_building_floor = level.building_floors[-1]
	
	_level = level
	if not _level.ui_layer.noise_map_button.pressed.is_connected(_on_toggle_noise_map_button_pressed):
		_level.ui_layer.noise_map_button.pressed.connect(_on_toggle_noise_map_button_pressed)
	
	return self

########## State methods. ##########

func enter() -> void:
	if not _level.ui_layer.enter_apt_creation_button.pressed.is_connected(_on_enter_apt_creation_button_pressed):
		_level.ui_layer.enter_apt_creation_button.pressed.connect(_on_enter_apt_creation_button_pressed)
	_level.ui_layer.enter_apt_creation_button.text = "Create apartments"
	
	_level.ui_layer.enter_apt_creation_button.visible = true
	_level.ui_layer.exit_apt_creation_button.visible = false
	_level.ui_layer.apt_creation_button.visible = false
	_level.ui_layer.clear_selected_tiles_button.visible = false
	_level.ui_layer.remove_apt_button.visible = false
	_level.ui_layer.tenant_placement_error_label.visible = false
	_level.ui_layer.unselect_apt_button.visible = false

func exit() -> void:
	pass

func process() -> void:
	var mouse_position : Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	
	_building_floor.highlight_apartment_at_global_position(mouse_position)
	if Input.is_action_just_pressed("left_click"):
		if _building_floor.get_apartment_at_global_position(mouse_position):
			_building_floor.highlight_adjacent_apartments_to_hovered()
			transition_to.emit("state_level_managing_apt")

func _on_enter_apt_creation_button_pressed() -> void:
	_level.ui_layer.enter_apt_creation_button.pressed.disconnect(_on_enter_apt_creation_button_pressed)
	transition_to.emit("state_level_selecting_tiles")

func _on_toggle_noise_map_button_pressed() -> void:
	_level.building_floors[-1].toggle_noise_map_display()
