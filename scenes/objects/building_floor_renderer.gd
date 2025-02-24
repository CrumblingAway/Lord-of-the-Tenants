class_name BuildingFloorRenderer extends Node

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

########## Fields. ##########

var building_floor : BuildingFloor:
	get:
		return building_floor
	set(other_building_floor):
		building_floor = other_building_floor

########## BuildingFloorRenderer methods. ##########

func init(other_building_floor: BuildingFloor) -> BuildingFloorRenderer:
	building_floor = other_building_floor
	
	return self

func render_selected_apartment(apartment: Apartment) -> void:
	# TODO: Implement.
	pass

func render_unselected_apartment(apartment: Apartment) -> void:
	# TODO: Implement.
	pass

func render_reserved_tile(tile: Vector2i) -> void:
	building_floor._tilemap.set_cell(Layer.HIGHLIGHT, tile, 0, Vector2i(5, 3))

func render_unreserved_tile(tile: Vector2i) -> void:
	building_floor._tilemap.set_cell(Layer.HIGHLIGHT, tile, -1)

func render_occupied_tile(tile: Vector2i, apartment: Apartment) -> void:
	building_floor._tilemap.set_cell(_get_apartment_floor_layer(apartment, ApartmentLayer.FLOOR), tile, 0, Vector2i(6, 0))

func render_unoccupied_tile(tile: Vector2i, apartment: Apartment) -> void:
	building_floor._tilemap.set_cell(_get_apartment_floor_layer(apartment, ApartmentLayer.FLOOR), tile, -1)

func render_hovered_apartment(apartment: Apartment) -> void:
	building_floor._tilemap.set_cells_terrain_connect(Layer.HIGHLIGHT, apartment.tiles, 0, 0, false)

func render_adjacent_apartment(apartment: Apartment) -> void:
	building_floor._tilemap.set_cells_terrain_connect(
		_get_apartment_floor_layer(apartment, ApartmentLayer.HIGHLIGHT),
		apartment.tiles,
		0,
		2,
		true
	)

func render_unadjacent_apartment(apartment: Apartment) -> void:
	building_floor._tilemap.clear_layer(_get_apartment_floor_layer(apartment, ApartmentLayer.HIGHLIGHT))

func render_remove_adjacent_apartments_to_hovered() -> void:
	pass

func render_apartment_occupied(apartment: Apartment) -> void:
	building_floor._tilemap.set_cells_terrain_connect(_get_apartment_floor_layer(apartment, ApartmentLayer.WALLS), apartment.tiles, 0, 1, true)

func render_apartment_unoccupied(apartment: Apartment) -> void:
	building_floor._tilemap.clear_layer(_get_apartment_floor_layer(apartment, ApartmentLayer.WALLS))

func clear_highlight() -> void:
	building_floor._tilemap.clear_layer(Layer.HIGHLIGHT)

func _get_apartment_floor_layer(apartment: Apartment, layer: ApartmentLayer) -> int:
	var apartment_idx : int = building_floor._apartments.find(apartment)
	assert(apartment_idx != -1, "Apartment not found.")
	return Layer.COUNT + ApartmentLayer.COUNT * apartment_idx + layer

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
