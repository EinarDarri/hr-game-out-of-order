extends PlayerState

@export_category("States")
@export var idle_state: PlayerState
@export var jumping_state: PlayerState
@export var running_state: PlayerState

func update_state():
	
	if player.get_jump() and player.can_jump():
		stateman.active_state = jumping_state
		return
		
	if player.is_on_floor():
		if player.get_movement_dir().x == 0:
			stateman.active_state = idle_state
		else:
			stateman.active_state = running_state
		return
