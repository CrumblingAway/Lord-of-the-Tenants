class_name TestFloorLevelCreate extends Test

var floor_level : FloorLevel

########## Test methods. ##########

func run() -> void:
	floor_level.init(5, 5)
	floor_level.register_tiles_as_apartment(
		[Vector2i(1, 2),
		Vector2i(1, 3)]
	)

func get_test_name() -> String:
	return "Create FloorLevel"

########## Node methods. ##########

func _ready() -> void:
	floor_level = preload("res://scenes/objects/floor_level.tscn").instantiate()
	add_child(floor_level)

func _process(delta: float) -> void:
	pass

