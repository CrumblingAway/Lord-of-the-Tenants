class_name TestLevelFlow extends Test

@onready var level : Level = $level

########## Test methods. ##########

func run() -> void:
	level.init(10, 10)

func get_test_name() -> String:
	return "LevelFlow"

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

