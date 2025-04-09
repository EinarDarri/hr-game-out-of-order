extends EnemyState

@export var distance_to_attack: float
@export var charge_state: EnemyState
@export var chase_speed: float = 10.0

func start_state() -> void:
	enemy.global_rotation = 0.0

func physics_update(delta: float) -> void:
	var player := Game.get_player()
	if enemy.global_position.distance_to(player.global_position) <= distance_to_attack:
		state_manager.active_state = charge_state
		return
	var dir_vec: Vector2 = enemy.global_position.direction_to(player.global_position)
	enemy.velocity += dir_vec * chase_speed * delta

func end_state() -> void:
	enemy.velocity = Vector2.ZERO
