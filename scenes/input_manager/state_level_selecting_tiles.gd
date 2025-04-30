class_name StateLevelSelectingTiles extends State

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor

var _level : Level

########## StateLevelIdle methods. ##########

func init(level: Level) -> StateLevelSelectingTiles:
	_building_floor = level.building_floors[-1]
	
	_level = level
	
	if not _level.ui_layer.exit_apt_creation_button.pressed.is_connected(_on_exit_apt_creation_button_pressed):
		_level.ui_layer.exit_apt_creation_button.pressed.connect(_on_exit_apt_creation_button_pressed)
	if not _level.ui_layer.apt_creation_button.pressed.is_connected(_on_apt_creation_button_pressed):
		_level.ui_layer.apt_creation_button.pressed.connect(_on_apt_creation_button_pressed)
	if not _level.ui_layer.clear_selected_tiles_button.pressed.is_connected(_on_clear_selected_tiles_button_pressed):
		_level.ui_layer.clear_selected_tiles_button.pressed.connect(_on_clear_selected_tiles_button_pressed)
	
	if not level.building_floors[-1].tenant_apartment_mismatch.is_connected(_on_tenant_apartment_problems_received):
		level.building_floors[-1].tenant_apartment_mismatch.connect(_on_tenant_apartment_problems_received)
	
	return self

########## State methods. ##########

func enter() -> void:
	_level.ui_layer.enter_apt_creation_button.visible = false
	_level.ui_layer.exit_apt_creation_button.visible = true
	_level.ui_layer.apt_creation_button.visible = true
	_level.ui_layer.clear_selected_tiles_button.visible = true

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

func _on_exit_apt_creation_button_pressed() -> void:
	_building_floor.unhighlight_adjacent_apartments_to_hovered()
	transition_to.emit("state_level_idle")

func _on_apt_creation_button_pressed() -> void:
	_building_floor.register_reserved_tiles_as_apartment()

func _on_clear_selected_tiles_button_pressed() -> void:
	_building_floor.unreserve_all_tiles()

func _on_tenant_apartment_problems_received(problems: Array) -> void:
	var problems_text : String = "[center]" + "\n".join(problems) + "[/center]"
	_level.ui_layer.tenant_placement_error_label.text = problems_text
	
	var tween = get_tree().create_tween()
	tween.tween_property(_level.ui_layer.tenant_placement_error_label, "visible", true, 0.0)
	tween.tween_property(_level.ui_layer.tenant_placement_error_label, "visible", false, 5.0)
