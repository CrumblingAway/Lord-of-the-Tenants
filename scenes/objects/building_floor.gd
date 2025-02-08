class_name BuildingFloor extends Node2D

enum Layer
{
	FLOOR,
	HIGHLIGHT,
	COUNT,
}

enum ApartmentLayer
{
	FLOOR,
	WALLS,
	HIGHLIGHT,
	COUNT,
}

########## Signals. ##########

signal tenant_apartment_mismatch(reasons: Array)
signal tenant_placed_successfully

########## Fields. ##########

@onready var _tilemap : TileMap = $TileMap

var _apartments : Array
var _highlighted_apartment : Apartment

var _reserved_tiles : Array

var _floor_below : BuildingFloor

########## BuildingFloor methods. ##########

func init(
	height: int,
	width: int,
	floor_below: BuildingFloor = null
) -> BuildingFloor:
	_floor_below = floor_below
	
	for x in range(width):
		for y in range(height):
			_tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i.ZERO)
	return self

func get_highlighted_apartment() -> Apartment:
	return _highlighted_apartment

func get_apartment_at_global_position(glb_position: Vector2) -> Apartment:
	return get_apartment_at_tile_position(_tilemap.local_to_map(glb_position))

func get_apartment_at_tile_position(tile: Vector2i) -> Apartment:
	for apartment in _apartments:
		if apartment.contains_tile_position(tile):
			return apartment
	return null

func is_tile_at_global_position_available(glb_position: Vector2) -> bool:
	var tile_position = _tilemap.local_to_map(glb_position)
	if not _tilemap.get_used_cells(0).has(tile_position):
		return false
	
	if _reserved_tiles.has(tile_position):
		return false
	
	for apartment in _apartments:
		if apartment.contains_tile_position(tile_position):
			return false
	return true

func is_tile_at_global_position_reserved(glb_position: Vector2) -> bool:
	return _reserved_tiles.has(_tilemap.local_to_map(glb_position))

func reserve_tile_at_global_position(glb_position: Vector2) -> void:
	_reserved_tiles.push_back(_tilemap.local_to_map(glb_position))

func unreserve_tile_at_global_position(glb_position: Vector2) -> void:
	var tile_index : int = _reserved_tiles.find(_tilemap.local_to_map(glb_position))
	if tile_index != -1:
		_reserved_tiles.remove_at(tile_index)

func unreserve_all_tiles() -> void:
	_reserved_tiles.clear()

func highlight_apartment_at_global_position(glb_position: Vector2) -> void:
	var apartment : Apartment = get_apartment_at_global_position(glb_position)
	if not apartment:
		_clear_highlight()
		_highlighted_apartment = null
		return
	
	if apartment == _highlighted_apartment:
		return
	else:
		_clear_highlight()
	
	_tilemap.set_cells_terrain_connect(Layer.HIGHLIGHT, apartment.tiles, 0, 0, false)
	_highlighted_apartment = apartment

func highlight_reserved_tiles() -> void:
	_clear_highlight()
	for tile in _reserved_tiles:
		_tilemap.set_cell(Layer.HIGHLIGHT, tile, 0, Vector2i(5, 3))

func highlight_adjacent_apartments_to_hovered() -> void:
	var adjacent_apartments : Array = _get_adjacent_apartments(_highlighted_apartment)
	for adjacent_apartment in adjacent_apartments:
		_tilemap.set_cells_terrain_connect(
			_get_apartment_floor_layer(adjacent_apartment, ApartmentLayer.HIGHLIGHT),
			adjacent_apartment.tiles,
			0,
			2,
			true
		)

func unhighlight_adjacent_apartments_to_hovered() -> void:
	var adjacent_apartments : Array = _get_adjacent_apartments(_highlighted_apartment)
	for adjacent_apartment in adjacent_apartments:
		_tilemap.clear_layer(_get_apartment_floor_layer(adjacent_apartment, ApartmentLayer.HIGHLIGHT))

func mark_apartment_occupied(apartment: Apartment) -> void:
	var floor_layer : int = _get_apartment_floor_layer(apartment, ApartmentLayer.FLOOR)
	for tile in apartment.tiles:
		_tilemap.set_cell(floor_layer, tile, 0, Vector2i(6, 0))

func place_tenant_in_apartment(tenant: Tenant, apartment: Apartment) -> bool:
	var apartment_problems : Array = _evaluate_apartment_for_tenant(apartment, tenant)
	if apartment_problems.size() > 0:
		tenant_apartment_mismatch.emit(apartment_problems)
		return false
	
	apartment.tenant = tenant
	tenant_placed_successfully.emit()
	
	return true

func clear_tenants() -> void:
	for apartment in _apartments:
		apartment.clear_tenant()

func clear_tenant(apartment: Apartment) -> void:
	apartment.clear_tenant()

func register_tiles_as_apartment(tiles: Array) -> void:
	# TODO: Only allow contiguous apartments.
	
	var apartment : Apartment = Apartment.new().init(tiles)
	_apartments.push_back(apartment)
	
	for layer_idx in range(ApartmentLayer.COUNT):
		_tilemap.add_layer(_tilemap.get_layers_count())
	
	_tilemap.set_cells_terrain_connect(_get_apartment_floor_layer(apartment, ApartmentLayer.WALLS), tiles, 0, 1, true)

func register_reserved_tiles_as_apartment() -> void:
	if _reserved_tiles.size() == 0:
		return
	register_tiles_as_apartment(_reserved_tiles)
	_reserved_tiles.clear()

func remove_apartment_at_global_position(glb_position: Vector2) -> void:
	var apartment : Apartment = get_apartment_at_global_position(glb_position)
	if not apartment \
	   or apartment.tenant:
		return
	
	var apartment_floor_layer : int = _get_apartment_floor_layer(apartment, ApartmentLayer.FLOOR)
	for _layer_idx in range(ApartmentLayer.COUNT):
		_tilemap.remove_layer(apartment_floor_layer)
	
	_apartments.erase(apartment)

func get_noise_input_in_apartment(apartment: Apartment) -> int:
	var noise_input : int = 0
	
	var adjacent_apartments : Array = _get_adjacent_apartments(apartment)
	for adjacent_apartment in adjacent_apartments:
		noise_input += adjacent_apartment.get_noise_output()
	var below_apartments : Array = _get_apartments_below(apartment)
	for apartment_below in below_apartments:
		noise_input += apartment_below.get_noise_output()
	
	return noise_input

func _get_adjacent_apartments(apartment: Apartment) -> Array:
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

func _get_apartments_below(apartment: Apartment) -> Array:
	if not _floor_below:
		return []
	
	var apartments_below : Array = []
	for tile in apartment.tiles:
		var apartment_below : Apartment = _floor_below.get_apartment_at_tile_position(tile)
		if apartment_below:
			apartments_below.push_back(apartment_below)
	return apartments_below

## Returns an array of Strings wherein each entry describes a reason why the tenant does not want
## the apartment. An empty array implies the tenant has no problems with the apartment.
func _evaluate_apartment_for_tenant(apartment: Apartment, tenant: Tenant) -> Array:
	var problems : Array = []
	if apartment.tenant != null:
		problems.push_back("The apartment is already occupied.")
	if get_noise_input_in_apartment(apartment) > tenant.noise_tolerance:
		problems.push_back("The apartment is too loud for the tenant.")
	
	# TODO: Optimize. Accumulate noise levels when placing tenants.
	var adjacent_apartments : Array = _get_adjacent_apartments(apartment)
	for adjacent_apartment in adjacent_apartments:
		var noise_input : int = tenant.noise_output
		var next_adjacent_apartments : Array = _get_adjacent_apartments(adjacent_apartment)
		
		var exceeds_adjacent_apartment_tolerance : bool = false
		for next_adjacent_apartment in next_adjacent_apartments:
			noise_input += next_adjacent_apartment.get_noise_output()
			if noise_input > adjacent_apartment.get_noise_tolerance():
				problems.push_back("Adjacent apartment would exceed noise tolerance.")
				exceeds_adjacent_apartment_tolerance = true
				break
		if exceeds_adjacent_apartment_tolerance:
			break
	
	return problems

func _get_apartment_floor_layer(apartment: Apartment, layer: ApartmentLayer) -> int:
	var apartment_idx : int = _apartments.find(apartment)
	assert(apartment_idx != -1, "Apartment not found.")
	return Layer.COUNT + ApartmentLayer.COUNT * apartment_idx + layer

func _clear_highlight() -> void:
	_tilemap.clear_layer(Layer.HIGHLIGHT)

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

