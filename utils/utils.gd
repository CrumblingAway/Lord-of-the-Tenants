class_name Utils extends Node

static func printdbg(message: String, callable: Callable) -> void:
	if not OS.is_debug_build():
		return
	
	if callable:
		print(message % callable.call())
	else:
		print(message)
