class_name StateLevelPlacingTenant extends State

########## Signals. ##########

signal finished_placing_tenants
signal add_tenant_back(tenant: Tenant)

########## Fields. ##########

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor

var _level : Level
var _apartment : Apartment

########## StateLevelPlacingTenant methods. ##########

func init(level: Level) -> StateLevelPlacingTenant:
	_building_floor = level.building_floors[-1]
	
	_level = level
	
	if not _level.ui_layer.done_button.pressed.is_connected(_on_finished_placing):
		_level.ui_layer.done_button.pressed.connect(_on_finished_placing)
	if not finished_placing_tenants.is_connected(level.advance_floor):
		finished_placing_tenants.connect(level.advance_floor)
	if not _level.ui_layer.remove_apt_button.pressed.is_connected(_on_remove_apt_button_pressed):
		_level.ui_layer.remove_apt_button.pressed.connect(_on_remove_apt_button_pressed)
	if not _level.ui_layer.unselect_apt_button.pressed.is_connected(_on_unselect_apt_button_pressed):
		_level.ui_layer.unselect_apt_button.pressed.connect(_on_unselect_apt_button_pressed)
	
	if not add_tenant_back.is_connected(_level.on_tenant_evicted):
		add_tenant_back.connect(_level.on_tenant_evicted)
	
	return self

func _on_tenant_selected(tenant_button: UILayer.TenantButton) -> void:
	if _building_floor.place_tenant_in_apartment(tenant_button.tenant, _apartment):
		Utils.printdbg("Tenant %s placed successfully.", func(): return [tenant_button.tenant])
		_building_floor.mark_apartment_occupied(_apartment)
		_building_floor.unhighlight_adjacent_apartments_to_hovered()
		for child in _level.ui_layer.tenant_buttons.get_children():
			if child == tenant_button:
				_level.ui_layer.tenant_buttons.remove_child(child)
		if _level.ui_layer.tenant_buttons.get_children().size() == 0:
			_level.ui_layer.done_button.disabled = false
		transition_to.emit("state_level_idle")
	else:
		Utils.printdbg("Failed to place tenant %s.", func(): return [tenant_button.tenant])

func _on_remove_apt_button_pressed() -> void:
	var hovered_apartment : Apartment = _apartment
	if not hovered_apartment:
		return
	
	if not hovered_apartment.tenant:
		_building_floor.remove_apartment(hovered_apartment)
	else:
		# TODO: Cleanup. Refer to Level::_init_tenant_buttons.
		add_tenant_back.emit(hovered_apartment.tenant)
		_level.ui_layer.done_button.disabled = true
		
		_building_floor.clear_tenant_from_apartment(hovered_apartment)
		_building_floor.unmark_apartment_occupied(hovered_apartment)
	
	_building_floor.unhighlight_adjacent_apartments_to_hovered()
	transition_to.emit("state_level_idle")

func _on_finished_placing() -> void:
	Utils.printdbg("Level completed!")
	_level.ui_layer.done_button.disabled = true
	finished_placing_tenants.emit()

func _format_apt_label() -> void:
	_level.ui_layer.apt_stats_label.text = "[center]Noise output: %d\nNoise input: %d/%s[/center]" %\
		[
			_apartment.get_noise_output(),
			_building_floor.get_noise_input_in_apartment(_apartment),
			"-" if not _apartment.tenant else str(_apartment.tenant.noise_tolerance)
		]

func _on_unselect_apt_button_pressed() -> void:
	_building_floor.unhighlight_adjacent_apartments_to_hovered()
	transition_to.emit("state_level_idle")

########## State methods. ##########

func enter() -> void:
	_apartment = _building_floor.get_highlighted_apartment()
	_format_apt_label()
	_level.ui_layer.apt_stats_label.visible = true
	
	for tenant_button in _level.ui_layer.tenant_buttons.get_children():
		tenant_button = tenant_button as UILayer.TenantButton
		if not tenant_button.button.pressed.is_connected(_on_tenant_selected.bind(tenant_button)):
			tenant_button.button.pressed.connect(_on_tenant_selected.bind(tenant_button))
	
	_level.ui_layer.remove_apt_button.visible = true
	_level.ui_layer.remove_apt_button.text = "Evict" if _apartment.tenant else "Demolish"
	_level.ui_layer.unselect_apt_button.visible = true

func exit() -> void:
	for tenant_button in _level.ui_layer.tenant_buttons.get_children():
		tenant_button = tenant_button as UILayer.TenantButton
		if tenant_button.button.pressed.is_connected(_on_tenant_selected):
			tenant_button.button.pressed.disconnect(_on_tenant_selected)
	
	_level.ui_layer.apt_stats_label.visible = false
	_level.ui_layer.unselect_apt_button.visible = false

func process() -> void:
	pass
