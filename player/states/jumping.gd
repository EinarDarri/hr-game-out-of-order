extends PlayerState

@export_category("States")
@export var falling_state: PlayerState

func update_state():
	if player.velocity.y >= 0:
		stateman.active_state = falling_state
