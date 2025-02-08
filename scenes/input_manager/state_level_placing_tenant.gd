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

########## StateLevelPlacingTenant methods. ##########

func init(level: Level) -> StateLevelPlacingTenant:
	_building_floor = level.building_floors[-1]
	_player = level.player
	_tenants = _player.tenants
	_tenant_buttons = level.ui_layer.tenant_buttons
	_done_button = level.ui_layer.done_button
	
	return self

func _on_tenant_selected(tenant_button: UILayer.TenantButton) -> void:
	if _building_floor.place_tenant_in_apartment(tenant_button.tenant, _building_floor.get_highlighted_apartment()):
		Utils.printdbg("Tenant %s placed successfully.", func(): return [tenant_button.tenant])
		_building_floor.mark_apartment_occupied(_building_floor.get_highlighted_apartment())
		for child in _tenant_buttons.get_children():
			if child == tenant_button:
				_tenant_buttons.remove_child(child)
		if _tenant_buttons.get_children().size() == 0:
			_done_button.disabled = false
	else:
		Utils.printdbg("Failed to place tenant %s.", func(): return [tenant_button.tenant])

func _on_finished_placing() -> void:
	Utils.printdbg("Level completed!")
	finished_placing_tenants.emit()

########## State methods. ##########

func enter() -> void:
	for tenant_button in _tenant_buttons.get_children():
		tenant_button = tenant_button as UILayer.TenantButton
		tenant_button.pressed.connect(_on_tenant_selected.bind(tenant_button))
	
	_done_button.pressed.connect(_on_finished_placing)
	_done_button.visible = true
	_done_button.disabled = true

func exit() -> void:
	for tenant_button in _tenant_buttons.get_children():
		tenant_button = tenant_button as UILayer.TenantButton
		tenant_button.pressed.disconnect(_on_tenant_selected)

func process() -> void:
	_building_floor.highlight_reserved_tiles()
	if Input.is_action_just_pressed("left_click"):
		pass
	elif Input.is_action_just_pressed("right_click"):
		_building_floor.unhighlight_adjacent_apartments_to_hovered()
		transition_to.emit("state_level_idle")
	elif Input.is_action_just_pressed("middle_click"):
		pass
