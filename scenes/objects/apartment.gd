class_name Apartment extends Node2D

########## Fields. ##########

var tenant : Tenant:
	get:
		return tenant
	set(new_tenant):
		tenant = new_tenant

var _tiles : Array[Vector2i]

########## Apartment methods. ##########

func init(tiles: Array[Vector2i]) -> Apartment:
	_tiles.assign(tiles)
	return self

func contains_tile_position(tile_position: Vector2i) -> bool:
	return _tiles.has(tile_position)

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

