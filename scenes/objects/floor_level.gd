class_name FloorLevel extends Node2D

enum Layers
{
	FLOOR,
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

var _floor_above : FloorLevel
var _floor_below : FloorLevel

########## FloorLevel methods. ##########

func init(height: int, width: int) -> FloorLevel:
	for x in range(width):
		for y in range(height):
			_tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i.ZERO)
	return self

func get_apartment_at_global_position(position: Vector2) -> Apartment:
	var tile_position : Vector2i = _tilemap.local_to_map(position)
	for apartment in _apartments:
		if apartment.contains_tile_position(tile_position):
			return apartment
	return null

func is_tile_at_global_position_available(position: Vector2) -> bool:
	var tile_position = _tilemap.local_to_map(position)
	if not _tilemap.get_used_cells(0).has(tile_position):
		return false
	
	if _reserved_tiles.has(tile_position):
		return false
	
	for apartment in _apartments:
		if apartment.contains_tile_position(tile_position):
			return false
	return true

func is_tile_at_global_position_reserved(position: Vector2) -> bool:
	return _reserved_tiles.has(_tilemap.local_to_map(position))

func reserve_tile_at_global_position(position: Vector2) -> void:
	_reserved_tiles.push_back(_tilemap.local_to_map(position))

func unreserve_tile_at_global_position(position: Vector2) -> void:
	var tile_index : int = _reserved_tiles.find(_tilemap.local_to_map(position))
	if tile_index != -1:
		_reserved_tiles.remove_at(tile_index)

func highlight_apartment_at_global_position(position: Vector2) -> void:
	var apartment : Apartment = get_apartment_at_global_position(position)
	if not apartment:
		clear_highlight()
		_highlighted_apartment = null
		return
	
	if apartment == _highlighted_apartment:
		return
	else:
		clear_highlight()
	
	var apartment_tiles : Array = apartment.tiles
	_tilemap.set_cells_terrain_connect(Layers.HIGHLIGHT, apartment.tiles, 0, 0, false)
	_highlighted_apartment = apartment

func highlight_reserved_tiles() -> void:
	clear_highlight()
	for tile in _reserved_tiles:
		_tilemap.set_cell(Layers.HIGHLIGHT, tile, 0, Vector2i(5, 3))

func clear_highlight() -> void:
	_tilemap.clear_layer(Layers.HIGHLIGHT)

func place_tenant_in_apartment(tenant: Tenant, apartment: Apartment) -> bool:
	if not _is_apartment_fit_for_tenant(apartment, tenant):
		return false
	
	apartment.tenant = tenant
	tenant_placed_successfully.emit()
	
	return true

func register_tiles_as_apartment(tiles: Array) -> void:
	_apartments.push_back(Apartment.new().init(tiles))
	_tilemap.add_layer(Layers.COUNT + _apartments.size() - 1)
	_tilemap.set_cells_terrain_connect(Layers.COUNT + _apartments.size() - 1, tiles, 0, 1, true)

func register_reserved_tiles_as_apartment() -> void:
	if _reserved_tiles.size() == 0:
		return
	register_tiles_as_apartment(_reserved_tiles)
	_reserved_tiles.clear()

func remove_apartment_at_global_position(position: Vector2) -> void:
	var apartment : Apartment = get_apartment_at_global_position(position)
	if not apartment:
		return
	
	var apartment_layer_idx : int = _apartments.find(apartment)
	_tilemap.remove_layer(Layers.COUNT + apartment_layer_idx)
	_apartments.erase(apartment)

func _is_apartment_fit_for_tenant(apartment: Apartment, tenant: Tenant) -> bool:
	return true

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

