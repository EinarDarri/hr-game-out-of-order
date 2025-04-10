extends EnemyState

@export_group("Variables")
## The time it takes to fully charge the spin attack
@export var charge_time: float
@export var launch_delay: float

@export_group("Other States")
@export var launch_state: EnemyState

## The speed at which the enemy rotates
var _rotation_speed: float = 0
## Affects how large of a factor delta is for the rotation acceleration
const ROTATION_MAGNITUDE = 0.25
## The time it takes to transition to the next state (launching)
var _time_to_launch: float

@export var targeting_crosshair: Sprite2D

@onready var launch_timer: Timer = $LaunchTimer
@onready var charge_timer: Timer = $ChargeTimer

func _ready() -> void:
	_time_to_launch = charge_time + launch_delay
	
func start_state() -> void:
	_rotation_speed = 0
	charge_timer.start(charge_time)
	launch_timer.start(_time_to_launch)
	targeting_crosshair.global_position = Game.get_player().global_position
	targeting_crosshair.visible = true

func end_state() -> void:
	targeting_crosshair.visible = false

func physics_update(delta: float) -> void:
	targeting_crosshair.global_position = targeting_crosshair.global_position.move_toward(Game.get_player().global_position, delta * 200)
	_rotation_speed = lerpf(_rotation_speed * delta,  1.0, (_time_to_launch - launch_timer.time_left) / charge_time)
	enemy.global_rotation += _rotation_speed
	targeting_crosshair.queue_redraw()

func _on_launch_timer_timeout() -> void:
	state_manager.active_state = launch_state

func attack_received(atk: Attack) -> void:
	enemy.velocity += (Game.get_player().global_position.direction_to(enemy.global_position) * (atk.knockback / 2))
