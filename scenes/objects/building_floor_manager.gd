class_name BuildingFloorManager extends Node

var building_floor : BuildingFloor:
	get:
		return building_floor
	set(other_building_floor):
		building_floor = other_building_floor
		_building_floor_renderer.building_floor = building_floor
		_connect_signals()
@onready var _building_floor_renderer : BuildingFloorRenderer = $building_floor_renderer

var _hovered_apartment: Apartment

########## BuildingFloorManager methods. ##########

func _connect_signals() -> void:
	building_floor.apartment_hovered.connect(_render_hovered_apartment)
	building_floor.tile_reserved.connect(_render_reserved_tile)
	building_floor.tile_unreserved.connect(_render_unreserved_tile)
	building_floor.tile_occupied.connect(_render_occupied_tile)
	building_floor.tile_unoccupied.connect(_render_unoccupied_tile)
	building_floor.apartment_registered.connect(_render_registered_apartment)
	building_floor.apartment_unregistered.connect(_render_unregistered_apartment)

func _render_hovered_apartment(apartment: Apartment) -> void:
	if apartment != _hovered_apartment:
		_building_floor_renderer.clear_highlight()
		_hovered_apartment = apartment
	_building_floor_renderer.render_hovered_apartment(apartment)

func _render_selected_apartment(apartment: Apartment) -> void:
	_building_floor_renderer.render_selected_apartment(apartment)
	for adjacent_apartment in building_floor._get_adjacent_apartments(apartment):
		_building_floor_renderer.render_adjacent_apartment(adjacent_apartment)

func _render_unselected_apartment(apartment: Apartment) -> void:
	_building_floor_renderer.render_unselected_apartment(apartment)
	for adjacent_apartment in building_floor._get_adjacent_apartments(apartment):
		_building_floor_renderer.render_unadjacent_apartment(adjacent_apartment)

func _render_registered_apartment(apartment: Apartment) -> void:
	for tile in apartment.tiles:
		_building_floor_renderer.render_unreserved_tile(tile)
	_building_floor_renderer.render_apartment_occupied(apartment)

func _render_unregistered_apartment(apartment: Apartment) -> void:
	_building_floor_renderer.render_apartment_unoccupied(apartment)

func _render_reserved_tile(tile: Vector2i) -> void:
	_building_floor_renderer.render_reserved_tile(tile)

func _render_unreserved_tile(tile: Vector2i) -> void:
	_building_floor_renderer.render_unreserved_tile(tile)

func _render_occupied_tile(tile: Vector2i, apartment: Apartment) -> void:
	_building_floor_renderer.render_occupied_tile(tile, apartment)

func _render_unoccupied_tile(tile: Vector2i, apartment: Apartment) -> void:
	_building_floor_renderer.render_unoccupied_tile(tile, apartment)

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
