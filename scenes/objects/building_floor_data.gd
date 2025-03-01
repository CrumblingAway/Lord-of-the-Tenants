class_name BuildingFloorData extends Object

########## Fields. ##########

var _height: int
var _width: int
var _apartments : Array

########## BuildingFloor methods. ##########

func init(
	height: int,
	width: int
) -> BuildingFloorData:
	_height = height
	_width = width
	
	return self

func get_apartment_at_tile_position(tile: Vector2i) -> Apartment:
	for apartment in _apartments:
		if apartment.contains_tile_position(tile):
			return apartment
	return null

func is_tile_available(tile: Vector2i) -> bool:
	for apartment in _apartments:
		if apartment.contains_tile_position(tile):
			return false
	return true

func place_tenant_in_apartment(tenant: Tenant, apartment: Apartment) -> void:
	apartment.tenant = tenant

func clear_tenants() -> void:
	for apartment in _apartments:
		apartment.clear_tenant()

func clear_tenant_from_apartment(apartment: Apartment) -> void:
	apartment.clear_tenant()

func register_tiles_as_apartment(tiles: Array) -> void:
	# TODO: Only allow contiguous apartments.
	
	var apartment : Apartment = Apartment.new().init(tiles)
	_apartments.push_back(apartment)

func get_adjacent_noise_input_in_apartment(apartment: Apartment) -> int:
	var noise_input : int = 0
	
	var adjacent_apartments : Array = get_adjacent_apartments(apartment)
	for adjacent_apartment in adjacent_apartments:
		noise_input += adjacent_apartment.get_noise_output()
	
	return noise_input

func get_adjacent_apartments(apartment: Apartment) -> Array:
	var adjacent_apartments : Array = []
	
	var four_connectivity : Array = [
		Vector2i.UP,
		Vector2i.DOWN,
		Vector2i.LEFT,
		Vector2i.RIGHT,
	]
	for tile in apartment.tiles:
		for direction in four_connectivity:
			var adjacent_apartment : Apartment = get_apartment_at_tile_position(tile + direction)
			if adjacent_apartment \
			   and not apartment == adjacent_apartment \
			   and not adjacent_apartments.has(adjacent_apartment):
				adjacent_apartments.push_back(adjacent_apartment)
	return adjacent_apartments
