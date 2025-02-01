class_name Utils extends Node

static var INT_MAX : int = 9223372036854775807

static var rng : RandomNumberGenerator = RandomNumberGenerator.new()

static func printdbg(message: String, callable: Callable = func(): return []) -> void:
	if not OS.is_debug_build():
		return
	
	var called_message : Array = callable.call()
	if called_message.size() > 0:
		print(message % called_message)
	else:
		print(message)

static func randi_range(from: int, to: int) -> int:
	return rng.randi_range(from, to)
