class_name Enemy extends CharacterBody2D

const SPEED = 100.0

var _health: int = 100

func _physics_process(delta: float) -> void:
	var dir = (Game.get_player().global_position - global_position).normalized()
	velocity.x = dir.x * SPEED
	move_and_slide()

func take_damage(amount: int) -> void:
	_health -= amount
	if _health <= 0:
		_health = 0
		queue_free()
