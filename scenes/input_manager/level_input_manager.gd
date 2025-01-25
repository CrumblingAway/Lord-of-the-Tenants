class_name LevelInputManager extends Node

########## Fields. ##########

var states : Array = []

@export var initial_state: State
var current_state : State:
	get:
		return current_state
	set(new_current_state):
#		if current_state:
#			remove_child(current_state)
#		current_state = new_current_state
#		add_child(current_state)
		current_state = new_current_state
var previous_state : State:
	get:
		return previous_state
	set(new_previous_state):
		previous_state = new_previous_state

########## InputManager methods. ##########

func init(level: Level) -> void:
	for state in states:
		match state.name:
			"state_level_idle":
				state.init(level)
			"state_level_selecting_tiles":
				state.init(level)
			"state_level_placing_tenant":
				state.init(level)
			_:
				pass
		state.transition_to.connect(transition_to_state)
	
	if initial_state:
		transition_to_state(initial_state.name)

func transition_to_state(destination_state_child_name: String) -> void:
	if current_state:
		current_state.exit()
		previous_state = current_state
	current_state = states.filter(func(state: State) -> bool: return state.name == destination_state_child_name)[0]
	current_state.enter()
	
	Utils.printdbg("LevelInputManager state: %s", func(): return [current_state.name])

func transition_to_previous_state() -> void:
	assert(current_state && previous_state)
	transition_to_state(previous_state.get_class())

########## Node methods. ##########

func _ready() -> void:
	for child_state in get_children():
		states.push_back(child_state)

func _process(_delta: float) -> void:
	if current_state:
		current_state.process()
