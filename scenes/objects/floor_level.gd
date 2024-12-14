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

func place_tenant_in_apartment(tenant: Tenant, apartment: Apartment) -> bool:
	if not _is_apartment_fit_for_tenant(apartment, tenant):
		return false
	
	apartment.tenant = tenant
	tenant_placed_successfully.emit()
	
	return true

func _is_apartment_fit_for_tenant(apartment: Apartment, tenant: Tenant) -> bool:
	return true

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

