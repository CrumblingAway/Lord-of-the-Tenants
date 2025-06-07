class_name Level extends Node

########## Fields. ##########

@onready var camera : Camera2D = $camera
@onready var input_manager : LevelInputManager = $level_input_manager
@onready var building_floors : Array = []
@onready var player : Player = $player
@onready var ui_layer : UILayer = $ui_layer

var _configs : Configs

var _floor_height: int
var _floor_width: int

########## Level methods. ##########

func init(
	configs: Configs,
	other_floor_height: int,
	other_floor_width: int
) -> Level:
	_configs = configs
	_floor_height = other_floor_height
	_floor_width = other_floor_width

	player.money_changed.connect(ui_layer._on_player_money_changed)
	
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
		player.money = _configs.initial_player_money
	
	player.tenants = _create_tenants_for_floor()
	_init_tenant_buttons(player.tenants)
	
	input_manager.init(self)

func _create_tenants_for_floor() -> Array:
	var num_tenants : int = int(sqrt(_floor_height * _floor_width))
	var tenants : Array = []
	tenants.resize(num_tenants)
	
	for i in range(num_tenants):
		tenants[i] = Tenant.new().init(Utils.rand_int_range(1, 10), Utils.rand_int_range(1, 5))
	
	return tenants

func _init_tenant_buttons(tenants: Array) -> void:
	for tenant in tenants:
		var tenant_button : UILayer.TenantButton = UILayer.TenantButton.new().init(tenant, _configs)
		ui_layer.tenant_buttons.add_child(tenant_button)

func on_tenant_evicted(tenant: Tenant) -> void:
	var tenant_button : UILayer.TenantButton = UILayer.TenantButton.new().init(tenant, _configs)
	ui_layer.tenant_buttons.add_child(tenant_button)
	player.tenants.push_back(tenant)

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
