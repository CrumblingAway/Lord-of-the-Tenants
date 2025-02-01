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

func init(other_tiles: Array) -> Apartment:
	self.tiles.assign(other_tiles)
	
	# TODO: Generate path for tenant walking animation.
	
	return self

func get_noise_output() -> int:
	return 0 if not tenant else tenant.noise_output

func get_noise_tolerance() -> int:
	return tenant.noise_tolerance if tenant else Utils.INT_MAX

func clear_tenant() -> void:
	tenant = null

func contains_tile_position(tile_position: Vector2i) -> bool:
	return tiles.has(tile_position)

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

