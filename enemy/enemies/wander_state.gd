extends EnemyState

var _dir: Vector2 = Vector2.LEFT

@export var chase_state: EnemyState

func start_state() -> void:
	_active = true
	enemy.rotation = 0.0

func end_state() -> void:
	_active = false

func physics_update(delta: float) -> void:
	enemy.global_position += _dir * enemy.movement_speed * delta

func _on_wall_checker_body_entered(body: Node2D) -> void:
	if !_active:
		return

	_dir *= -1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !_active:
		return
	
	state_manager.active_state = chase_state
