extends EnemyState

var _dir: Vector2 = Vector2.RIGHT

@export var wall_ray: RayCast2D
@export_group("Variables")
@export var speed: float = 50

@export_group("Other States")
@export var chase_state: EnemyState

@export var animation_player: AnimationPlayer

var _active: bool

func start_state() -> void:
	_active = true
	enemy.rotation = 0.0
	animation_player.play("wander")

func end_state() -> void:
	_active = false
	animation_player.stop()

func physics_update(delta: float) -> void:
	if wall_ray.is_colliding():
		if enemy.velocity.x == 0:
			wall_ray.target_position *= -1
			_dir *= -1
		enemy.velocity.x = move_toward(enemy.velocity.x, 0, speed * delta)
	else:
		enemy.velocity.x = move_toward(enemy.velocity.x, _dir.x * speed, delta*speed)

func _on_aggro_radius_body_entered(_body: Node2D) -> void:
	if !_active:
		return

	state_manager.active_state = chase_state
