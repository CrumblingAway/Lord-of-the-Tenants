class_name StateLevelPlacingTenant extends State

########## Signals. ##########

signal finished_placing_tenants

########## Fields. ##########

var _building_floor : BuildingFloor:
	get:
		return _building_floor
	set(new_building_floor):
		_building_floor = new_building_floor
var _player : Player:
	get:
		return _player
	set(new_player):
		_player = new_player
var _tenants : Array

var _tenant_buttons : VBoxContainer
var _done_button : Button
var _remove_apt_button : Button

########## StateLevelPlacingTenant methods. ##########

func init(level: Level) -> StateLevelPlacingTenant:
	_building_floor = level.building_floors[-1]
	_player = level.player
	_tenants = _player.tenants
	_tenant_buttons = level.ui_layer.tenant_buttons
	_done_button = level.ui_layer.done_button
	_remove_apt_button = level.ui_layer.remove_apt_button
	
	if not _done_button.pressed.is_connected(_on_finished_placing):
		_done_button.pressed.connect(_on_finished_placing)
	if not finished_placing_tenants.is_connected(level.advance_floor):
		finished_placing_tenants.connect(level.advance_floor)
	if not _remove_apt_button.pressed.is_connected(_on_remove_apt_button_pressed):
		_remove_apt_button.pressed.connect(_on_remove_apt_button_pressed)
	
	return self

func _on_tenant_selected(tenant_button: UILayer.TenantButton) -> void:
	if _building_floor.place_tenant_in_apartment(tenant_button.tenant, _building_floor.get_highlighted_apartment()):
		Utils.printdbg("Tenant %s placed successfully.", func(): return [tenant_button.tenant])
		_building_floor.mark_apartment_occupied(_building_floor.get_highlighted_apartment())
		_building_floor.unhighlight_adjacent_apartments_to_hovered()
		for child in _tenant_buttons.get_children():
			if child == tenant_button:
				_tenant_buttons.remove_child(child)
		if _tenant_buttons.get_children().size() == 0:
			_done_button.disabled = false
		transition_to.emit("state_level_idle")
	else:
		Utils.printdbg("Failed to place tenant %s.", func(): return [tenant_button.tenant])

func _on_remove_apt_button_pressed() -> void:
	var hovered_apartment : Apartment = _building_floor.get_highlighted_apartment()
	if not hovered_apartment:
		return
	
	if not hovered_apartment.tenant:
		_building_floor.remove_apartment(hovered_apartment)
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
	
	_building_floor.unhighlight_adjacent_apartments_to_hovered()
	transition_to.emit("state_level_idle")

func _on_finished_placing() -> void:
	Utils.printdbg("Level completed!")
	finished_placing_tenants.emit()

########## State methods. ##########

func enter() -> void:
	for tenant_button in _tenant_buttons.get_children():
		tenant_button = tenant_button as UILayer.TenantButton
		if not tenant_button.pressed.is_connected(_on_tenant_selected.bind(tenant_button)):
			tenant_button.pressed.connect(_on_tenant_selected.bind(tenant_button))
	
	_remove_apt_button.visible = true
	_remove_apt_button.text = "Evict" if _building_floor.get_highlighted_apartment().tenant else "Demolish"

func exit() -> void:
	for tenant_button in _tenant_buttons.get_children():
		tenant_button = tenant_button as UILayer.TenantButton
		if tenant_button.pressed.is_connected(_on_tenant_selected):
			tenant_button.pressed.disconnect(_on_tenant_selected)

func process() -> void:
	_building_floor.highlight_reserved_tiles()
	# TODO: Maybe find way to do this using left click without conflicting with tenant button click.
	if Input.is_action_just_pressed("right_click"):
		_building_floor.unhighlight_adjacent_apartments_to_hovered()
		transition_to.emit("state_level_idle")
