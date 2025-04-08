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
	#print((rot*180)/PI)

func physics_update(delta: float) -> void:
	enemy.global_position += _dir * launch_speed * delta
	if enemy.global_position.distance_to(_start_pos) >= max_distance:
		state_manager.active_state = chase_state
