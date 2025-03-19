class_name Enemy extends CharacterBody2D

const SPEED = 100.0

var _health: int = 100

func _physics_process(delta: float) -> void:
	# store direction as vector with no y coordinate for consistent x movement
	var dirVector = Vector2((Game.get_player().global_position.x-global_position.x),0)
	var dir = dirVector.normalized()
	velocity.x = dir.x * SPEED
	print("velocity: ",dir)
	move_and_slide()

func take_damage(amount: int) -> void:
	_health -= amount
	if _health <= 0:
		_health = 0
		queue_free()
