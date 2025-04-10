class_name PlayerRunState extends PlayerState

@export_category("States")
@export var idle_state: PlayerIdleState
@export var air_state: PlayerAirState
@export var dash_state: PlayerDashState
@export var attacking_state: PlayerAttackState

@export var footstep_sfx: Array[AudioStream]

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var footsteps: AudioStreamPlayer = $Footsteps

const RUNNING_SPEED = 250.0

var _footstep_played := false
var _current_footstep := 0

func start_state() -> void:
	player.animated_sprite_2d.play("Running")

func update_state(delta):
	if animated_sprite_2d.frame == 0:
		if _footstep_played:
			return
		
		footsteps.stream = footstep_sfx[_current_footstep]
		footsteps.play()
		_current_footstep = (_current_footstep + 1) % len(footstep_sfx)
	else:
		_footstep_played = false

func physics_update(delta):
	
	if Input.is_action_just_pressed("attack"):
		stateman.active_state = attacking_state
		return
	
	if player.get_movement_dir().x == 0:
		stateman.active_state = idle_state
		return
		
	player.velocity.x = move_toward(player.velocity.x, player.get_movement_dir().x * RUNNING_SPEED, delta * RUNNING_SPEED * 7)
		
	if Input.is_action_just_pressed("move_jump") or not player.is_on_floor():
		stateman.active_state = air_state
		return
	
	if Input.is_action_just_pressed("move_dash"):
		dash_state.previus_state = self
		stateman.active_state = dash_state
		return

func end_state() -> void:
	player.animated_sprite_2d.stop()

func attack_received(attack: Attack) -> void:
	player.hit_sfx.pitch_scale = randf_range(0.9, 1.1)
	player.hit_sfx.play()
	player.apply_damage(attack.damage)
	player.global_position += Vector2.UP * 2
	player.velocity = attack.knockback
	stateman.active_state = air_state
