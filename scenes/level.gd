class_name Level extends Node

########## Fields. ##########

@onready var camera : Camera2D = $camera
@onready var input_manager : LevelInputManager = $level_input_manager
@onready var building_floors : Array = []
@onready var player : Player = $player
@onready var ui_layer : UILayer = $ui_layer

var _floor_height: int
var _floor_width: int

########## Level methods. ##########

func init(
	other_floor_height: int,
	other_floor_width: int
) -> Level:
	_floor_height = other_floor_height
	_floor_width = other_floor_width
	
	return self

func advance_floor() -> void:
	assert(is_node_ready())
	
	if building_floors.size() > 1:
		remove_child(building_floors[-2])
	
	var new_building_floor : BuildingFloor = preload("res://scenes/objects/building_floor.tscn").instantiate()
	add_child(new_building_floor)
	
	new_building_floor.init(_floor_height, _floor_width, building_floors[-1] if building_floors.size() > 0 else null)
	building_floors.push_back(new_building_floor)
	if building_floors.size() == 1:
		camera.global_position = Vector2(_floor_width, _floor_height) * new_building_floor._tilemap.tile_set.tile_size.x / 2
	
	player.tenants = _create_tenants_for_floor()
	_init_tenant_buttons(player.tenants)
	
	input_manager.init(self)

func _create_tenants_for_floor() -> Array:
	var num_tenants : int = int(sqrt(_floor_height * _floor_width))
	var tenants : Array = []
	tenants.resize(num_tenants)
	
	for i in range(num_tenants):
		tenants[i] = Tenant.new().init(Utils.rand_int_range(1, num_tenants), 1)
	
	return tenants

func _init_tenant_buttons(tenants: Array) -> void:
	for tenant in tenants:
		var tenant_button : UILayer.TenantButton = UILayer.TenantButton.new().init(tenant)
		tenant_button.text = "Noise Tolerance: %d\nNoise Output: %d" % [tenant.noise_tolerance, tenant.noise_output]
		ui_layer.tenant_buttons.add_child(tenant_button)

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

