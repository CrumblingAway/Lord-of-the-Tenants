class_name TestBuildingFloorCreate extends Test

var building_floor : BuildingFloor

########## Test methods. ##########

func run() -> void:
	building_floor.init(5, 5)

func get_test_name() -> String:
	return "Create BuildingFloor"

########## Node methods. ##########

func _ready() -> void:
	building_floor = preload("res://scenes/objects/building_floor.tscn").instantiate()
	add_child(building_floor)

func _process(delta: float) -> void:
	pass

