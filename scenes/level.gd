class_name Level extends Node

########## Fields. ##########

@onready var input_manager : LevelInputManager = $level_input_manager
@onready var building_floor : BuildingFloor = $building_floor

########## Level methods. ##########

func init(
	floor_height: int,
	floor_width: int
) -> Level:
	building_floor.init(floor_height, floor_width)
	input_manager.init(building_floor)
	
	return self

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

