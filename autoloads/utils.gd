extends Node

static func printdbg(str: String) -> void:
	if OS.is_debug_build():
		print(str)
