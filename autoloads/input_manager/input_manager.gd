extends Node

########## Fields. ##########

var current_state : State:
	get:
		return current_state
	set(new_current_state):
		current_state = new_current_state

########## InputManager methods. ##########

func transition_to_state(destination_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = destination_state
	destination_state.enter()

########## Node methods. ##########

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if current_state:
		current_state.process()
