class_name StateLevelPlacingTenant extends State

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

########## StateLevelPlacingTenant methods. ##########

func init(level: Level) -> StateLevelPlacingTenant:
	_building_floor = level.building_floors[-1]
	_player = level.player
	_tenants = _player.tenants
	_tenant_buttons = level.ui_layer.tenant_buttons
	
	return self

func _on_tenant_selected(tenant: Tenant) -> void:
	if _building_floor.place_tenant_in_apartment(tenant, _building_floor.get_highlighted_apartment()):
		Utils.printdbg("Tenant %s placed successfully.", func(): return [tenant])
		# TODO: Remove tenant from tenants.
		pass
	else:
		Utils.printdbg("Failed to place tenant %s.", func(): return [tenant])

########## State methods. ##########

func enter() -> void:
	for tenant_button in _tenant_buttons.get_children():
		tenant_button = tenant_button as UILayer.TenantButton
		tenant_button.pressed.connect(_on_tenant_selected.bind(tenant_button.tenant))

func exit() -> void:
	for tenant_button in _tenant_buttons.get_children():
		tenant_button = tenant_button as UILayer.TenantButton
		tenant_button.pressed.disconnect(_on_tenant_selected)

func process() -> void:
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	_building_floor.highlight_reserved_tiles()
	if Input.is_action_just_pressed("left_click"):
		pass
	elif Input.is_action_just_pressed("right_click"):
		_building_floor.unhighlight_adjacent_apartments_to_hovered()
		transition_to.emit("state_level_idle")
	elif Input.is_action_just_pressed("middle_click"):
		pass
