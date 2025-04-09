class_name PlayerAttackState extends PlayerState

@onready var attack_timer: Timer = $AttackTimer
@onready var delay_timer: Timer = $Delay
@onready var shaker_component_2d: ShakerComponent2D = $"../../Camera2D/ShakerComponent2D"
@onready var attack_sfx: AudioStreamPlayer = $AttackSFX
@onready var wall_check: Area2D = $"../../LookDirection/WallCheck"

@export_category("States")
@export var idle_state: PlayerState
@export var air_state: PlayerState
@export var running_state: PlayerState

var player_velocity: Vector2 
var is_attacking := false
var attack_buffer := false

func start_state() -> void:
	player.animated_sprite_2d.animation_finished.connect(_on_animation_finish)
	player.animated_sprite_2d.play("Slash1")
	player_velocity = player.velocity
	
	if wall_check.has_overlapping_bodies():
		player.velocity = Vector2(10*player.get_facing(),0)
	else:
		player.velocity = Vector2(200*player.get_facing(),0)
	
	attack_timer.start()
	is_attacking = true
	attack_buffer = false
	attack_sfx.pitch_scale = randf_range(0.6, 1.3)
	attack_sfx.play()
	
	for enemy: Enemy in player.slash.get_overlapping_bodies():
		var attack := Attack.new()
		attack.damage = 30
		attack.knockback = Vector2(200*player.get_facing(),-100)
		enemy.take_damage(attack)
		shaker_component_2d.play_shake()

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack_buffer = true
	
	if is_attacking:
		return

	if not player.is_on_floor() or Input.is_action_just_pressed("move_jump"):
		stateman.active_state = air_state
		return

	var movedir := player.get_movement_dir()

	if movedir.x == 0:
		stateman.active_state = idle_state
		return
	else:
		stateman.active_state = running_state
		return
	
func end_state() -> void:
	player.animated_sprite_2d.animation_finished.disconnect(_on_animation_finish)
	player.velocity = player_velocity
	player.animated_sprite_2d.stop()


func _on_attack_timer_timeout() -> void:
	is_attacking = false
	delay_timer.start()
	end_state()

func _on_animation_finish() -> void:
	if attack_buffer:
		player.animated_sprite_2d.play("Slash2")
		

func _on_delay_timeout() -> void:
	if attack_buffer:
		start_state()
