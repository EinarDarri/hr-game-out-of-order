extends PlayerState

@export_category("States")
@export var jump_state: PlayerState
@export var dash_state: PlayerState
@export var running_state: PlayerState
@export var lookup_state: PlayerState
@export var lookdown_state: PlayerState

func start_state() -> void:
	player.animated_sprite_2d.play("Idle")

func update_state(delta):
	
	player.velocity.x = move_toward(player.velocity.x, 0,Player.SPEED*delta*4) #TODO test what value works best on a scale from 3 - 5
	
	if player.get_jump() and player.can_jump():
		stateman.active_state = jump_state
		player.extra_jump_counter = player.EXTRA_JUMP_AMOUNT
		return
		
	if player.get_dash() and player.can_dash():
		stateman.active_state = dash_state
		return

	var movedir := player.get_movement_dir()

	if movedir.x != 0:
		stateman.active_state = running_state
		return

	if movedir.y == 0:
		pass
	elif movedir.y > 0:
		stateman.active_state = lookdown_state
		return
	else:
		stateman.active_state = lookup_state 
		return
		
	

func end_state() -> void:
	player.animated_sprite_2d.stop()
