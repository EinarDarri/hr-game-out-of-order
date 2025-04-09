class_name PlayerRunState extends PlayerState

@export_category("States")
@export var idle_state: PlayerIdleState
@export var air_state: PlayerAirState
@export var dash_state: PlayerDashState
@export var attacking_state: PlayerAttackState

func start_state() -> void:
	player.animated_sprite_2d.play("Running")

func physics_update(delta):
	
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
		dash_state.previus_state = self
		stateman.active_state = dash_state
		return

func end_state() -> void:
	player.animated_sprite_2d.stop()

func gui() -> void:
	ImGui.Text("Velocity: %d" % player.velocity.x)

func attack_received(attack: Attack) -> void:
	player.hit_sfx.pitch_scale = randf_range(0.9, 1.1)
	player.hit_sfx.play()
	player.apply_damage(attack.damage)
	player.global_position += Vector2.UP * 2
	player.velocity = attack.knockback
	stateman.active_state = air_state
