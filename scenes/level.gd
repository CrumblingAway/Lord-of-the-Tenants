class_name Level extends Node

########## Fields. ##########

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
		remove_child(building_floors[-3])
	
	var new_building_floor : BuildingFloor = preload("res://scenes/objects/building_floor.tscn").instantiate()
	add_child(new_building_floor)
	
	building_floors.push_back(new_building_floor)
	new_building_floor.init(_floor_height, _floor_width)
	input_manager.init(self)
	player.tenants = create_tenants_for_floor()

func create_tenants_for_floor() -> Array:
	var num_tenants : int = int(sqrt(_floor_height * _floor_width))
	var tenants : Array = []
	tenants.resize(num_tenants)
	tenants.fill(Tenant.new().init(num_tenants, 1))
	return tenants

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

