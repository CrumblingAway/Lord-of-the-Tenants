class_name Level extends Node

########## Fields. ##########

@onready var input_manager : LevelInputManager = $level_input_manager
@onready var building_floors : Array = []
@onready var player : Player = $player

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
	if building_floors.size() > 0:
		pass
	else:
		building_floors.push_back($building_floor)
		building_floors[0].init(_floor_height, _floor_width)
		input_manager.init(building_floors[0], player)
	

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

