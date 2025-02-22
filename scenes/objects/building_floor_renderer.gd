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
		_connect_signals()

########## BuildingFloorRenderer methods. ##########

func init(other_building_floor: BuildingFloor) -> BuildingFloorRenderer:
	building_floor = other_building_floor
	
	return self

func highlight_selected_apartment() -> void:
	# TODO: Implement.
	pass

func unhighlight_selected_apartment() -> void:
	# TODO: Implement.
	pass

func highlight_reserved_tiles(tile: Vector2i) -> void:
	building_floor._tilemap.set_cell(Layer.HIGHLIGHT, tile, 0, Vector2i(5, 3))

func highlight_hovered_apartment(apartment: Apartment) -> void:
	building_floor._tilemap.set_cells_terrain_connect(Layer.HIGHLIGHT, apartment.tiles, 0, 0, false)

func highlight_adjacent_apartment(apartment: Apartment) -> void:
	building_floor._tilemap.set_cells_terrain_connect(
		_get_apartment_floor_layer(apartment, ApartmentLayer.HIGHLIGHT),
		apartment.tiles,
		0,
		2,
		true
	)

func unhighlight_adjacent_apartments_to_hovered() -> void:
	pass

func mark_apartment_occupied(apartment: Apartment) -> void:
	pass

func unmark_apartment_occupied(apartment: Apartment) -> void:
	pass

func _clear_highlight() -> void:
	building_floor._tilemap.clear_layer(Layer.HIGHLIGHT)

func _get_apartment_floor_layer(apartment: Apartment, layer: ApartmentLayer) -> int:
	var apartment_idx : int = building_floor._apartments.find(apartment)
	assert(apartment_idx != -1, "Apartment not found.")
	return Layer.COUNT + ApartmentLayer.COUNT * apartment_idx + layer

func _connect_signals() -> void:
	assert(building_floor)
	
	building_floor.apartment_hovered.connect(highlight_hovered_apartment)

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
