class_name PlayerAttackState extends PlayerState

@onready var delay_timer: Timer = $Delay
@onready var shaker_component_2d: ShakerComponent2D = $"../../Camera2D/ShakerComponent2D"
@onready var attack_sfx: AudioStreamPlayer = $AttackSFX

@export_category("States")
@export var idle_state: PlayerState
@export var air_state: PlayerState
@export var running_state: PlayerState

var attack_buffer := false
var attack_just_started := false

var slashes: Array[String] = ["Slash1", "Slash2", "Slash1"]
var current_slash := 0

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finish)

func start_state() -> void:
	current_slash = 0
	slash()

func slash() -> void:
	animated_sprite_2d.play(slashes[current_slash])
	player.velocity = _get_attack_velocity()
	
	attack_buffer = false
	attack_sfx.pitch_scale = randf_range(0.6, 1.3)
	attack_sfx.play()
	
	# I hate this
	attack_just_started = true
	
	for enemy: Enemy in player.slash.get_overlapping_bodies():
		var attack := Attack.new()
		attack.damage = 30
		attack.knockback = Vector2(200*player.get_facing(),-100)
		enemy.take_damage(attack)
		shaker_component_2d.play_shake()

func update_state(delta: float) -> void:
	player.velocity = player.velocity.lerp(Vector2.ZERO, delta * 5)
	
	if Input.is_action_just_pressed("attack") and not attack_just_started:
		attack_buffer = true
	
	attack_just_started = false

func end_state() -> void:
	animated_sprite_2d.stop()
	delay_timer.start()

func gui() -> void:
	ImGui.Text("Attack: [%d] %s" % [current_slash, slashes[current_slash]])
	ImGui.Text("Frame: %d" % animated_sprite_2d.frame)

func _on_animation_finish() -> void:
	if current_slash + 1 < len(slashes) and attack_buffer:
		current_slash += 1
		slash()
		return
	
	_exit_state()

func _exit_state() -> void:
	if not player.is_on_floor() or Input.is_action_just_pressed("move_jump"):
		stateman.active_state = air_state
		return

	if player.get_movement_dir().x == 0:
		stateman.active_state = idle_state
		return
	
	stateman.active_state = running_state

func _get_attack_velocity() -> Vector2:
	if player.get_movement_dir().x == 0:
		return Vector2(100 * player.get_facing(), 0)
	else:
		return Vector2(800 * player.get_facing(), 0)

func can_enter() -> bool:
	return delay_timer.is_stopped()
