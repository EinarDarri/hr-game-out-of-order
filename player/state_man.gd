class_name StateManager extends Node



@export var active_state: PlayerState:
	set(new_state):
		if active_state != null:
			active_state.end_state()
			new_state.start_state()
		active_state = new_state
		print(new_state)
