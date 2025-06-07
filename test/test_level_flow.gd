class_name TestLevelFlow extends Test

@export var configs : Configs
@onready var level : Level = $level

########## Test methods. ##########

func run() -> void:
	level.init(configs, 5, 5)
	level.advance_floor()

func get_test_name() -> String:
	return "LevelFlow"

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
