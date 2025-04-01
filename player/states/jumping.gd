extends PlayerState

@export_category("States")
@export var falling_state: PlayerState


func start_state() -> void:
	player.animated_sprite_2d.play("Jump")
	player.velocity.y = player.JUMP_VELOCITY
	player.jump_buffered = false

func update_state(delta):
	if player.get_jump() and player.can_jump():
		player.extra_jump_counter -= 1
		player.velocity.y = player.JUMP_VELOCITY
		player.jump_buffered = false
		return
		
	player.velocity.x = move_toward(player.velocity.x, player.get_movement_dir().x * player.SPEED, delta*Player.SPEED*4)
	
	if player.velocity.y >= 0:
		stateman.active_state = falling_state

func end_state() -> void:
	player.animated_sprite_2d.stop()
