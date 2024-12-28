class_name Test extends Node2D

########## Signals. ##########

signal test_end

########## Test methods. ##########

func run() -> void:
	pass

func get_test_name() -> String:
	return ""

func expect(expression: Variant, expectation: Variant) -> void:
	if expression != expectation:
		print("Failure: " + str(expression) + " != " + str(expectation))
	else:
		print("Success: " + str(expression) + " == " + str(expectation))

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

