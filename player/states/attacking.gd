extends PlayerState

@onready var attack_timer: Timer = $AttackTimer
@onready var deleay_timer: Timer = $Deleay

@export_category("States")
@export var idle_state: PlayerState
@export var air_state: PlayerState
@export var running_state: PlayerState

var player_velocity: Vector2 
var is_attacking := false
var attack_buffer := false

func start_state() -> void:
	player.animated_sprite_2d.play("Slash")
	player_velocity = player.velocity
	player.velocity = Vector2(500*player.get_facing(),0)
	attack_timer.start()
	is_attacking = true
	attack_buffer = false
	
	for enemy: Enemy in player.slash.get_overlapping_bodies():
		enemy.take_damage(30)

func update_state(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack_buffer = true
	
	if is_attacking:
		return

	if not player.is_on_floor() or Input.is_action_just_pressed("move_jump"):
		stateman.active_state = air_state
		return

	var movedir := player.get_movement_dir()

	if movedir.x != 0:
		stateman.active_state = running_state
		return
	
func end_state() -> void:
	player.velocity = player_velocity
	player.animated_sprite_2d.stop()


func _on_attack_timer_timeout() -> void:
	is_attacking = false
	deleay_timer.start()
	end_state()


func _on_deleay_timeout() -> void:
	if attack_buffer:
		start_state()
