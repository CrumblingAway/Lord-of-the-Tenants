class_name State extends RefCounted

########## Signals. ##########

signal transition_to(state: State)

########## State methods. ##########

func enter() -> void:
	pass

func exit() -> void:
	pass

func process() -> void:
	pass

