class_name FloorLevel extends Node2D

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

signal tenant_apartment_mismatch(reasons: Array[String])
signal tenant_placed_successfully

########## Fields. ##########

@onready var _tilemap : TileMap = $TileMap

var _apartments : Array
var _highlighted_apartment : Apartment

var _reserved_tiles : Array

var _floor_below : FloorLevel

########## FloorLevel methods. ##########

func init(height: int, width: int) -> FloorLevel:
	for x in range(width):
		for y in range(height):
			_tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i.ZERO)
	return self

func get_apartment_at_global_position(glb_position: Vector2) -> Apartment:
	return _get_apartment_at_tile_position(_tilemap.local_to_map(glb_position))

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
		clear_highlight()
		_highlighted_apartment = null
		return
	
	if apartment == _highlighted_apartment:
		return
	else:
		clear_highlight()
	
	_tilemap.set_cells_terrain_connect(Layer.HIGHLIGHT, apartment.tiles, 0, 0, false)
	_highlighted_apartment = apartment

func highlight_reserved_tiles() -> void:
	clear_highlight()
	for tile in _reserved_tiles:
		_tilemap.set_cell(Layer.HIGHLIGHT, tile, 0, Vector2i(5, 3))

func highlight_adjacent_apartments_to_hovered() -> void:
	_highlight_adjacent_apartments(_highlighted_apartment)

func unhighlight_adjacent_apartments_to_hovered() -> void:
	_unhighlight_adjacent_apartments(_highlighted_apartment)

func clear_highlight() -> void:
	_tilemap.clear_layer(Layer.HIGHLIGHT)

func place_tenant_in_apartment(tenant: Tenant, apartment: Apartment) -> bool:
	if not _is_apartment_fit_for_tenant(apartment, tenant):
		return false
	
	apartment.tenant = tenant
	tenant_placed_successfully.emit()
	
	return true

func register_tiles_as_apartment(tiles: Array) -> void:
	# TODO: Only allow contiguous apartments.
	
	var apartment : Apartment = Apartment.new().init(tiles)
	_apartments.push_back(apartment)
	_add_apartment_layers()
	_tilemap.set_cells_terrain_connect(_get_apartment_floor_layer(apartment, ApartmentLayer.WALLS), tiles, 0, 1, true)

func register_reserved_tiles_as_apartment() -> void:
	if _reserved_tiles.size() == 0:
		return
	register_tiles_as_apartment(_reserved_tiles)
	_reserved_tiles.clear()

func remove_apartment_at_global_position(glb_position: Vector2) -> void:
	var apartment : Apartment = get_apartment_at_global_position(glb_position)
	if not apartment:
		return
	
	_remove_apartment_layers(apartment)
	_apartments.erase(apartment)

func _get_apartment_at_tile_position(tile: Vector2i) -> Apartment:
	for apartment in _apartments:
		if apartment.contains_tile_position(tile):
			return apartment
	return null

func _get_noise_input_in_apartment(apartment: Apartment) -> int:
	var noise_input : int = 0
	
	var adjacent_apartments : Array = _get_adjacent_apartments(apartment)
	for adjacent_apartment in adjacent_apartments:
		noise_input += _get_noise_output_from_apartment(adjacent_apartment)
	var below_apartments : Array = _get_apartments_below(apartment)
	for apartment_below in below_apartments:
		noise_input += _floor_below._get_noise_output_from_apartment(apartment_below)
	
	return noise_input

func _get_noise_output_from_apartment(apartment: Apartment) -> int:
	return apartment.get_noise_output()

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
			var adjacent_apartment : Apartment = _get_apartment_at_tile_position(tile + direction)
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
		apartments_below.push_back(_floor_below._get_apartment_at_tile_position(tile))
	return apartments_below

func _is_apartment_fit_for_tenant(apartment: Apartment, tenant: Tenant) -> bool:
	return _get_noise_input_in_apartment(apartment) <= tenant.noise_tolerance

func _highlight_adjacent_apartments(apartment: Apartment) -> void:
	var adjacent_apartments : Array = _get_adjacent_apartments(apartment)
	for adjacent_apartment in adjacent_apartments:
		_tilemap.set_cells_terrain_connect(
			_get_apartment_floor_layer(adjacent_apartment, ApartmentLayer.HIGHLIGHT),
			adjacent_apartment.tiles,
			0,
			2,
			true
		)
	
	Utils.printdbg(
		"Adjacent noise: %s",
		func(): 
			var total_noise : int = 0
			var noises : Array = []
			for adjacent_apartment in adjacent_apartments:
				total_noise += adjacent_apartment.get_noise_output()
				noises.push_back(str(adjacent_apartment.get_noise_output()))
			return "%d [%s]" % [total_noise, noises.reduce(func(accum: String, noise: String): return accum + " " + noise)]
	)

func _unhighlight_adjacent_apartments(apartment: Apartment) -> void:
	var adjacent_apartments : Array = _get_adjacent_apartments(apartment)
	for adjacent_apartment in adjacent_apartments:
		_tilemap.clear_layer(_get_apartment_floor_layer(adjacent_apartment, ApartmentLayer.HIGHLIGHT))

func _get_apartment_floor_layer(apartment: Apartment, layer: ApartmentLayer) -> int:
	var apartment_idx : int = _apartments.find(apartment)
	assert(apartment_idx != -1, "Apartment not found.")
	return Layer.COUNT + ApartmentLayer.COUNT * apartment_idx + layer

func _add_apartment_layers() -> void:
	for layer_idx in range(ApartmentLayer.COUNT):
		_tilemap.add_layer(_tilemap.get_layers_count())

func _remove_apartment_layers(apartment: Apartment) -> void:
	var apartment_floor_layer : int = _get_apartment_floor_layer(apartment, ApartmentLayer.FLOOR)
	for _layer_idx in range(ApartmentLayer.COUNT):
		_tilemap.remove_layer(apartment_floor_layer)

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

