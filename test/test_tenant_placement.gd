class_name TestTenantPlacement extends Test

var building_floor : BuildingFloor

########## Test methods. ##########

func run() -> void:
	building_floor.init(10, 10)
	
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
		building_floor.register_tiles_as_apartment(apartment_tiles)
	
	var tenants : Array = [
		Tenant.new().init(5, 1),
		Tenant.new().init(3, 4),
		Tenant.new().init(4, 1),
		Tenant.new().init(2, 1),
		Tenant.new().init(1, 1),
	]
	
	expect(building_floor.place_tenant_in_apartment(tenants[0], building_floor.get_apartment_at_tile_position(apartments_tiles[3][0])), true)
	expect(building_floor.place_tenant_in_apartment(tenants[1], building_floor.get_apartment_at_tile_position(apartments_tiles[3][0])), false)
	expect(building_floor.place_tenant_in_apartment(tenants[1], building_floor.get_apartment_at_tile_position(apartments_tiles[7][0])), true)
	expect(building_floor.place_tenant_in_apartment(tenants[2], building_floor.get_apartment_at_tile_position(apartments_tiles[6][0])), true)
	expect(building_floor.place_tenant_in_apartment(tenants[3], building_floor.get_apartment_at_tile_position(apartments_tiles[2][0])), false)
	expect(building_floor.place_tenant_in_apartment(tenants[4], building_floor.get_apartment_at_tile_position(apartments_tiles[2][0])), false)

func get_test_name() -> String:
	return "Place Tenant"

########## Node methods. ##########

func _ready() -> void:
	building_floor = preload("res://scenes/objects/building_floor.tscn").instantiate()
	add_child(building_floor)

func _process(_delta: float) -> void:
	pass
