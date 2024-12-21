class_name Utils extends Node

static func printdbg(message: String) -> void:
	if OS.is_debug_build():
		print(message)
