extends PlayerState

@export_category("States")
@export var idle_state: PlayerState
@export var lookdown_up: PlayerState
@export var jump_state: PlayerState
@export var dash_state: PlayerState
@export var running_state: PlayerState

func start_state() -> void:
	pass

func update_state(_delta):
	if player.get_jump() == true:
		stateman.active_state = jump_state
		return
		
	if player.get_dash() == true:
		stateman.active_state = dash_state
		return

	var movedir := player.get_movement_dir()

	if movedir.x != 0:
		stateman.active_state = running_state
		return

	if movedir.y == 0:
		stateman.active_state = idle_state
		return
	elif movedir.y < 0:
		stateman.active_state = lookdown_up
		return

func end_state() -> void:
	pass
