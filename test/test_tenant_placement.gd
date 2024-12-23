class_name TestTenantPlacement extends Test

var floor_level : FloorLevel

########## Test methods. ##########

func run() -> void:
	InputManager._mode = InputManager.Mode.LEVEL_IDLE
	InputManager._floor_level = floor_level
	
	floor_level.init(10, 10)
	
	var apartments_tiles : Array = [
		[
			Vector2i(0, 0),
			Vector2i(1, 0),
			Vector2i(2, 0),
			Vector2i(3, 0),
			Vector2i(2, 1),
			Vector2i(3, 1),
		],
		[
			Vector2i(0, 1),
			Vector2i(1, 1),
			Vector2i(0, 2),
			Vector2i(1, 2),
		],
		[
			Vector2i(3, 3),
			Vector2i(3, 4),
			Vector2i(3, 5),
			Vector2i(4, 3),
			Vector2i(4, 4),
			Vector2i(4, 5),
			Vector2i(4, 6),
		],
		[
			Vector2i(1, 4),
			Vector2i(2, 4),
			Vector2i(2, 3),
			Vector2i(2, 2),
			Vector2i(3, 2),
			Vector2i(4, 2),
			Vector2i(4, 1),
		],
		[
			Vector2i(5, 2),
			Vector2i(6, 2),
			Vector2i(6, 3),
			Vector2i(6, 4),
		],
		[
			Vector2i(5, 1),
			Vector2i(6, 1),
			Vector2i(7, 1),
			Vector2i(7, 2),
			Vector2i(7, 3),
			Vector2i(7, 4),
		],
		[
			Vector2i(6, 5),
			Vector2i(7, 5),
			Vector2i(8, 4),
			Vector2i(8, 5),
			Vector2i(8, 6),
			Vector2i(9, 4),
			Vector2i(9, 5),
			Vector2i(9, 6),
		],
		[
			Vector2i(5, 5),
			Vector2i(5, 6),
			Vector2i(5, 7),
			Vector2i(5, 8),
			Vector2i(5, 9),
		],
		[
			Vector2i(7, 7),
			Vector2i(7, 8),
			Vector2i(7, 9),
			Vector2i(8, 8),
			Vector2i(8, 9),
		],
	]
	for apartment_tiles in apartments_tiles:
		floor_level.register_tiles_as_apartment(apartment_tiles)
	
	var tenants : Array = [
		Tenant.new().init(5, 1),
		Tenant.new().init(3, 4),
		Tenant.new().init(4, 1),
		Tenant.new().init(2, 1),
		Tenant.new().init(1, 1),
	]
	
	_print_apartment_placement(floor_level.place_tenant_in_apartment(tenants[0], floor_level.get_apartment_at_tile_position(apartments_tiles[3][0])))
	_print_apartment_placement(floor_level.place_tenant_in_apartment(tenants[1], floor_level.get_apartment_at_tile_position(apartments_tiles[3][0])))
	_print_apartment_placement(floor_level.place_tenant_in_apartment(tenants[1], floor_level.get_apartment_at_tile_position(apartments_tiles[7][0])))
	_print_apartment_placement(floor_level.place_tenant_in_apartment(tenants[2], floor_level.get_apartment_at_tile_position(apartments_tiles[6][0])))
	_print_apartment_placement(floor_level.place_tenant_in_apartment(tenants[3], floor_level.get_apartment_at_tile_position(apartments_tiles[2][0])))
	_print_apartment_placement(floor_level.place_tenant_in_apartment(tenants[4], floor_level.get_apartment_at_tile_position(apartments_tiles[2][0])))

func get_test_name() -> String:
	return "Place Tenant"

########## TestTenantPlacement methods. ##########

func _print_apartment_placement(success: bool):
	print("success" if success else "failure")

########## Node methods. ##########

func _ready() -> void:
	floor_level = preload("res://scenes/objects/floor_level.tscn").instantiate()
	add_child(floor_level)

func _process(_delta: float) -> void:
	pass
