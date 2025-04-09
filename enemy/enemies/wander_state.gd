extends EnemyState

var _dir: Vector2 = Vector2.RIGHT

@export var chase_state: EnemyState
@export var speed: float = 50
@export var wall_ray: RayCast2D

func start_state() -> void:
	_active = true
	enemy.rotation = 0.0

func end_state() -> void:
	_active = false

func physics_update(delta: float) -> void:
	if wall_ray.is_colliding():
		var col: Node2D = wall_ray.get_collider()
		
		var wall_pos := col.get_global_position()
		var enemy_pos := enemy.get_global_position()
		
		
		if enemy.velocity.x == 0:
			wall_ray.target_position *= -1
			_dir *= -1
			
			
		enemy.velocity.x = move_toward(enemy.velocity.x, 0, speed * delta)
		
	else:
		enemy.velocity.x = move_toward(enemy.velocity.x, _dir.x * speed, delta*speed)
	

func _on_aggro_radius_body_entered(body: Node2D) -> void:
	if !_active:
		return

	state_manager.active_state = chase_state
