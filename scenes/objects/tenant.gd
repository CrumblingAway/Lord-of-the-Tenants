class_name Tenant extends Node2D

########## Consts. ##########

const DEFAULT_NOISE_TOLERANCE : int = 10
const DEFAULT_NOISE_OUTPUT    : int = 1

########## Fields. ##########

@export var noise_tolerance : int = DEFAULT_NOISE_TOLERANCE:
	get:
		return noise_tolerance
@export var noise_output    : int = DEFAULT_NOISE_OUTPUT:
	get:
		return noise_output

########## Tenant methods. ##########

func init(other_noise_tolerance: int, other_noise_output: int) -> Tenant:
	self.noise_tolerance = other_noise_tolerance
	self.noise_output    = other_noise_output
	
	return self

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
