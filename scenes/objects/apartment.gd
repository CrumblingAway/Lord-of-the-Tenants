class_name Apartment extends Node2D

########## Fields. ##########

var tenant : Tenant:
	get:
		return tenant
	set(new_tenant):
		tenant = new_tenant

var tiles : Array[Vector2i]:
	get:
		return tiles

########## Apartment methods. ##########

func init(other_tiles: Array[Vector2i]) -> Apartment:
	tiles.assign(other_tiles)
	return self

func contains_tile_position(tile_position: Vector2i) -> bool:
	return tiles.has(tile_position)

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

