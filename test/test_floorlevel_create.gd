class_name TestFloorLevelCreate extends Test

var floor_level : FloorLevel

########## Test methods. ##########

func run() -> void:
	var apartment_tiles_array : Array = [
		[
			Vector2i(0, 0),
			Vector2i(0, 1),
			Vector2i(1, 0),
			Vector2i(2, 0),
		],
		[
			Vector2i(1, 1),
			Vector2i(1, 2),
			Vector2i(2, 1),
			Vector2i(2, 2),
		],
		[
			Vector2i(1, 4),
			Vector2i(2, 4),
			Vector2i(3, 4),
		],
		[
			Vector2i(4, 3),
			Vector2i(4, 4),
		],
	]
	
	floor_level.init(5, 5)
	for apartment_tiles in apartment_tiles_array:
		floor_level.register_tiles_as_apartment(apartment_tiles)

func get_test_name() -> String:
	return "Create FloorLevel"

########## Node methods. ##########

func _ready() -> void:
	floor_level = preload("res://scenes/objects/floor_level.tscn").instantiate()
	add_child(floor_level)
	
	InputManager._mode = InputManager.Mode.LEVEL
	InputManager._floor_level = floor_level

func _process(delta: float) -> void:
	pass

