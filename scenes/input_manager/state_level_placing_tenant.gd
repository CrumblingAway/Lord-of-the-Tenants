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

########## StateLevelPlacingTenant methods. ##########

func init(other_building_floor: BuildingFloor, other_player: Player) -> StateLevelPlacingTenant:
	_building_floor = other_building_floor
	_player = other_player
	
	return self

func _on_tenant_selected(tenant: Tenant) -> void:
	if _building_floor.place_tenant_in_apartment(tenant, _building_floor.get_highlighted_apartment()):
		Utils.printdbg("Tenant %s placed successfully.", func(): return [tenant])
		# TODO: Remove tenant from tenants.
		pass
	else:
		Utils.printdbg("Failed to place tenant %s.", func(): return [tenant])

func _init_tenant_buttons(tenants: Array) -> void:
	var tenant_button : Button = Button.new()
	tenant_button.button_down.connect(_on_tenant_selected.bind(tenants[0]))
	tenant_button.global_position = Vector2i(100, 100)
	tenant_button.text = "NT: %d, NO: %d" % [tenants[0].noise_tolerance, tenants[0].noise_output]
	get_tree().root.add_child(tenant_button)

########## State methods. ##########

func enter() -> void:
	_tenants = _player.tenants
	_init_tenant_buttons(_tenants)

func exit() -> void:
	pass

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
