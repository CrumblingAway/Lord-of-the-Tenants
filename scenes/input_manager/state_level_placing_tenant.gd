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

func init(other_building_floor: BuildingFloor) -> StateLevelPlacingTenant:
	_building_floor = other_building_floor
	
	return self

func enable_tenant_buttons() -> void:
	pass

func _on_tenant_selected(tenant_idx: int) -> void:
	pass

########## State methods. ##########

func enter() -> void:
	enable_tenant_buttons()

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
