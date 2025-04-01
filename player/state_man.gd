class_name StateManager extends Node



@export var active_state: PlayerState:
	set(new_state):
		active_state = new_state
		print(new_state)
