class_name Utils extends Node

static func printdbg(message: String, callable: Callable = func(): return []) -> void:
	if not OS.is_debug_build():
		return
	
	var called_message : Array = callable.call()
	if called_message.size() > 0:
		print(message % called_message)
	else:
		print(message)
