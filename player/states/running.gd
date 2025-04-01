extends PlayerState

@export_category("States")
@export var idle_state: PlayerState
@export var jump_state: PlayerState
@export var dash_state: PlayerState

func update_state():
	
	if player.get_movement_dir().x == 0:
		stateman.active_state = idle_state
		return
		
	if player.get_jump():
		stateman.active_state = jump_state
		return
	
	if player.get_dash():
		stateman.active_state = dash_state
		return
