class_name Apartment extends Node2D

########## Fields. ##########

var tenant : Tenant:
	get:
		return tenant
	set(new_tenant):
		tenant = new_tenant

var tiles : Array:
	get:
		return tiles

# TODO: Add rent.

########## Apartment methods. ##########

func init(tiles: Array) -> Apartment:
	self.tiles.assign(tiles)
	
	# TODO: Generate path for tenant walking animation.
	
	return self

func contains_tile_position(tile_position: Vector2i) -> bool:
	return tiles.has(tile_position)

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

