class_name StateLevelIdle extends State

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor
var _player : Player

var _tenant_buttons : VBoxContainer
var _done_button : Button
var _transition_to_apt_creation_button : Button
var _apt_creation_button : Button
var _clear_selected_tiles_button : Button
var _remove_apt_button : Button

########## StateLevelIdle methods. ##########

func init(level: Level) -> StateLevelIdle:
	_building_floor = level.building_floors[-1]
	
	_player = level.player
	_tenant_buttons = level.ui_layer.tenant_buttons
	_done_button = level.ui_layer.done_button
	_done_button.disabled = true
	_transition_to_apt_creation_button = level.ui_layer.transition_to_apt_creation_button
	_apt_creation_button = level.ui_layer.apt_creation_button
	_clear_selected_tiles_button = level.ui_layer.clear_selected_tiles_button
	_remove_apt_button = level.ui_layer.remove_apt_button
	
	return self

########## State methods. ##########

func enter() -> void:
	if not _transition_to_apt_creation_button.pressed.is_connected(_on_transition_to_apt_creation_button_pressed):
		_transition_to_apt_creation_button.pressed.connect(_on_transition_to_apt_creation_button_pressed)
	_transition_to_apt_creation_button.text = "Create apartments"
	
	_apt_creation_button.visible = false
	_clear_selected_tiles_button.visible = false
	_remove_apt_button.visible = false

func exit() -> void:
	pass

func process() -> void:
	var mouse_position : Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	
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
			transition_to.emit("state_level_managing_apt")
	elif Input.is_action_just_pressed("right_click"):
		var hovered_apartment : Apartment = _building_floor.get_apartment_at_global_position(mouse_position)
		if hovered_apartment:
			if not hovered_apartment.tenant:
				_building_floor.remove_apartment_at_global_position(mouse_position)
			else:
				# TODO: Cleanup. Refer to Level::_init_tenant_buttons.
				var tenant : Tenant = hovered_apartment.tenant
				var tenant_button : UILayer.TenantButton = UILayer.TenantButton.new().init(tenant)
				tenant_button.text = "NT: %d, NO: %d" % [tenant.noise_tolerance, tenant.noise_output]
				_tenant_buttons.add_child(tenant_button)
				_player.tenants.push_back(tenant)
				_done_button.disabled = true
				
				_building_floor.clear_tenant_from_apartment(hovered_apartment)
				_building_floor.unmark_apartment_occupied(hovered_apartment)

func _on_transition_to_apt_creation_button_pressed() -> void:
	_transition_to_apt_creation_button.pressed.disconnect(_on_transition_to_apt_creation_button_pressed)
	transition_to.emit("state_level_selecting_tiles")
