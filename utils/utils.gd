class_name Utils extends Node

static func printdbg(message: String, callable: Callable) -> void:
	if OS.is_debug_build():
		if callable:
			print(message % callable.call())
		else:
			print(message)
