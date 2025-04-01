extends PlayerState

@export_category("States")
@export var air_state: PlayerState
@export var dash_state: PlayerState
@export var running_state: PlayerState
@export var attacking_state: PlayerState

func start_state() -> void:
	player.animated_sprite_2d.play("Idle")

func update_state(delta):
	
	player.velocity.x = move_toward(player.velocity.x, 0,Player.SPEED*delta*4) #TODO test what value works best on a scale from 3 - 5
	
	if Input.is_action_just_pressed("attack"):
		stateman.active_state = attacking_state
		return
	
	if not player.is_on_floor() or Input.is_action_just_pressed("move_jump"):
		stateman.active_state = air_state
		return
		
	if Input.is_action_just_pressed("move_dash") and player.can_dash():
		stateman.active_state = dash_state
		return

	var movedir := player.get_movement_dir()

	if movedir.x != 0:
		stateman.active_state = running_state
		return
		
	

func end_state() -> void:
	player.animated_sprite_2d.stop()
