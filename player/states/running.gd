extends PlayerState

@export_category("States")
@export var idle_state: PlayerState
@export var jump_state: PlayerState
@export var dash_state: PlayerState

func start_state() -> void:
	player.animated_sprite_2d.play("Running")

func update_state(delta):
	
	if player.get_movement_dir().x == 0:
		stateman.active_state = idle_state
		return
		
	player.velocity.x = move_toward(player.velocity.x, player.get_movement_dir().x * player.SPEED, delta*Player.SPEED*4)
		
	if player.get_jump():
		stateman.active_state = jump_state
		return
	
	if player.get_dash():
		stateman.active_state = dash_state
		return

func end_state() -> void:
	player.animated_sprite_2d.stop()
