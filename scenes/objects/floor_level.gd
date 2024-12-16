class_name FloorLevel extends Node2D

########## Signals. ##########

signal tenant_apartment_mismatch(reasons: Array[String])
signal tenant_placed_successfully

########## Fields. ##########

@onready var _tilemap : TileMap = $TileMap

var _apartments : Array[Apartment]
var _highlighted_apartment : Apartment

var _floor_above : FloorLevel
var _floor_below : FloorLevel

########## FloorLevel methods. ##########

func init(height: int, width: int) -> FloorLevel:
	for x in range(width):
		for y in range(height):
			_tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i.ZERO)
	return self

func get_apartment_at_global_position(position: Vector2i) -> Apartment:
	var tile_position : Vector2i = _tilemap.local_to_map(position)
	for apartment in _apartments:
		if apartment.contains_tile_position(tile_position):
			return apartment
	return null

func highlight_apartment_at_global_position(position: Vector2i) -> void:
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
	_tilemap.set_cells_terrain_connect(1, apartment.tiles, 0, 0, false)
	_highlighted_apartment = apartment
	
func clear_highlight() -> void:
	_tilemap.clear_layer(1)

func place_tenant_in_apartment(tenant: Tenant, apartment: Apartment) -> bool:
	if not _is_apartment_fit_for_tenant(apartment, tenant):
		return false
	
	apartment.tenant = tenant
	tenant_placed_successfully.emit()
	
	return true

func register_tiles_as_apartment(tiles: Array) -> bool:
	_apartments.push_back(Apartment.new().init(tiles))
	return true

func _is_apartment_fit_for_tenant(apartment: Apartment, tenant: Tenant) -> bool:
	return true

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

