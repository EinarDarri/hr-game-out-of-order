extends PlayerState

@export_category("States")
@export var idle_state: PlayerState
@export var air_state: PlayerState
@export var dash_state: PlayerState
@export var attacking_state: PlayerState

func start_state() -> void:
	player.animated_sprite_2d.play("Running")

func update_state(delta):
	
	if Input.is_action_just_pressed("attack"):
		stateman.active_state = attacking_state
		return
	
	if player.get_movement_dir().x == 0:
		stateman.active_state = idle_state
		return
		
	player.velocity.x = move_toward(player.velocity.x, player.get_movement_dir().x * player.SPEED, delta*Player.SPEED*7)
		
	if Input.is_action_just_pressed("move_jump") or not player.is_on_floor():
		stateman.active_state = air_state
		return
	
	if Input.is_action_just_pressed("move_dash"):
		stateman.active_state = dash_state
		return

func end_state() -> void:
	player.animated_sprite_2d.stop()
