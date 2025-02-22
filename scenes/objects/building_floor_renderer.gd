class_name BuildingFloorRenderer extends Node

@export var _building_floor : BuildingFloor

########## BuildingFloorRenderer methods. ##########

func highlight_selected_apartment() -> void:
	pass

func highlight_reserved_tiles() -> void:
	pass

func highlight_apartment_at_global_position(glb_position: Vector2) -> void:
	pass

func highlight_adjacent_apartments_to_hovered() -> void:
	pass

func unhighlight_adjacent_apartments_to_hovered() -> void:
	pass

func mark_apartment_occupied(apartment: Apartment) -> void:
	pass

func unmark_apartment_occupied(apartment: Apartment) -> void:
	pass

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
