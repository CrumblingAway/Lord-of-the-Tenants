class_name FloorLevel extends Node2D

########## Signals. ##########

signal tenant_apartment_mismatch(reasons: Array[String])
signal tenant_placed_successfully

########## Fields. ##########

@onready var _tilemap : TileMap = $TileMap

var _apartments : Array[Apartment]

var _floor_above : FloorLevel
var _floor_below : FloorLevel

########## FloorLevel methods. ##########

func init(height: int, width: int) -> FloorLevel:
	for x in range(width):
		for y in range(height):
			_tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i.ZERO)
	return self

func get_apartment_at_tile_position(tile_position: Vector2i) -> Apartment:
	for apartment in _apartments:
		if apartment.contains_tile_position(tile_position):
			return apartment
	return null

func highlight_apartment_at_tile_position(tile_position: Vector2i) -> void:
	var apartment : Apartment = get_apartment_at_tile_position(tile_position)
	if not apartment:
		return
	var apartment_tiles : Array[Vector2i] = apartment.tiles
	
	# Bounding lines.
	var left   : int = apartment_tiles.reduce(func(a, b): return min(a.x, b.x))
	var right  : int = apartment_tiles.reduce(func(a, b): return max(a.x, b.x))
	var top    : int = apartment_tiles.reduce(func(a, b): return min(a.y, b.y))
	var bottom : int = apartment_tiles.reduce(func(a, b): return max(a.y, b.y))
	
	# Surrounding tiles.
	var surrounding_tiles : Array[Vector2i]
	for x in range(left - 1, right + 1):
		for y in range(top - 1, bottom + 1):
			if (apartment_tiles.has(Vector2i(x + 1, y)) \
			   or apartment_tiles.has(Vector2i(x, y + 1))) \
			   and not apartment_tiles.has(Vector2i(x, y)):
				surrounding_tiles.push_back(Vector2i(x, y))
	for x in range(left - 1, right + 1):
		if apartment_tiles.has(Vector2i(x, bottom)):
			surrounding_tiles.push_back(Vector2i(x, bottom + 1))
	for y in range(top - 1, bottom + 1):
		if apartment_tiles.has(Vector2i(right, y)):
			surrounding_tiles.push_back(Vector2i(right + 1, y))
	if apartment_tiles.has(Vector2i(left, top)):
		surrounding_tiles.push_back(Vector2i(left - 1, top - 1))
	if apartment_tiles.has(Vector2i(left, bottom)):
		surrounding_tiles.push_back(Vector2i(left - 1, bottom + 1))
	if apartment_tiles.has(Vector2i(right, top)):
		surrounding_tiles.push_back(Vector2i(right + 1, top - 1))
	if apartment_tiles.has(Vector2i(right, bottom)):
		surrounding_tiles.push_back(Vector2i(right + 1, bottom + 1))
	
	_tilemap.set_cells_terrain_connect(1, surrounding_tiles, 0, 0)
	
func clear_highlight() -> void:
	pass

func place_tenant_in_apartment(tenant: Tenant, apartment: Apartment) -> bool:
	if not _is_apartment_fit_for_tenant(apartment, tenant):
		return false
	
	apartment.tenant = tenant
	tenant_placed_successfully.emit()
	
	return true

func register_tiles_as_apartment(tiles: Array[Vector2i]) -> bool:
	_apartments.push_back(Apartment.new().init(tiles))
	return true

func _is_apartment_fit_for_tenant(apartment: Apartment, tenant: Tenant) -> bool:
	return true

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

