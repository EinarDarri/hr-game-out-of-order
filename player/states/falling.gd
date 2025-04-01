extends PlayerState

@export_category("States")
@export var idle_state: PlayerState
@export var jumping_state: PlayerState
@export var running_state: PlayerState

func start_state() -> void:
	pass

func update_state(delta):
	
	player.velocity.x = move_toward(player.velocity.x, player.get_movement_dir().x * player.SPEED, delta*Player.SPEED*4)
	
	if player.get_jump() and player.can_jump():
		player.extra_jump_counter -= 1
		stateman.active_state = jumping_state
		return
		
	if player.is_on_floor():
		if player.get_movement_dir().x == 0:
			stateman.active_state = idle_state
		else:
			stateman.active_state = running_state
		return

func end_state() -> void:
	pass
