class_name Tenant extends Node2D

########## Consts. ##########

const DEFAULT_NOISE_TOLERANCE : int = 10
const DEFAULT_NOISE_OUTPUT    : int = 1

########## Fields. ##########

@export var _noise_tolerance : int = DEFAULT_NOISE_TOLERANCE:
	get:
		return _noise_tolerance
@export var _noise_output    : int = DEFAULT_NOISE_OUTPUT:
	get:
		return _noise_output

########## Tenant methods. ##########

########## Node2D methods. ##########

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
