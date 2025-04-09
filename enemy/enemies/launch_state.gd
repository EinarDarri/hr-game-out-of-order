extends EnemyState

@export var launch_speed: float = 10.0
@export var chase_state: EnemyState
@export var max_distance: float

var _dir: Vector2
var _start_pos: Vector2
var _end_pos: Vector2

func start_state() -> void:
	_dir = enemy.global_position.direction_to(Game.get_player().get_center())
	_start_pos = enemy.global_position
	_end_pos = _dir * max_distance
	var rot = atan2(_dir.y, _dir.x) + PI/2
	enemy.global_rotation = rot
	enemy.velocity += _dir * launch_speed

func physics_update(delta: float) -> void:
	enemy.velocity = Vector2(
		move_toward(enemy.velocity.x, 0, ( absf(_dir.x) *launch_speed * delta) / 2),
		move_toward(enemy.velocity.y, 0, ( absf(_dir.y) *launch_speed * delta) / 2)
	)
	
	if enemy.global_position.distance_to(_start_pos) >= max_distance:
		state_manager.active_state = chase_state

func end_state() -> void:
	enemy.velocity = Vector2.ZERO
