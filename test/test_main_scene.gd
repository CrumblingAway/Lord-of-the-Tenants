class_name TestMainScene extends Node2D

########## Fields. ##########

@export var test_scene : PackedScene
var test : Test
@export var exit_on_test_end : bool = true

var _start_time_ms : float # Unix timestamp in milliseconds.

########## TestMainScene methods. ##########

func on_test_end() -> void:
	print("Test %s completed in %.03fs." % [
		test.get_test_name(),
		(Time.get_unix_time_from_system() - _start_time_ms) * 0.001
	])
	if exit_on_test_end:
		get_tree().quit()

########## Node2D methods. ##########

func _ready() -> void:
	if not test_scene:
		print("No test chosen.")
		return
	
	test = test_scene.instantiate()
	add_child(test)

	test.test_end.connect(on_test_end)
	print("Running test %s" % test.get_test_name())
	test.run()
	
	_start_time_ms = Time.get_unix_time_from_system()

func _process(_delta: float) -> void:
	pass
