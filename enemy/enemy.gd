class_name Enemy extends CharacterBody2D

const SPEED = 100.0

var _health: int = 100
var _max_health: int = 100

@export var take_damage_particle: PackedScene

func get_health() -> int:
	return _health

func get_max_health() -> int:
	return _max_health

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# store direction as vector with no y coordinate for consistant x movement
	var dirVector = Vector2((Game.get_player().global_position.x-global_position.x),0)
	var dir = dirVector.normalized()
	velocity.x = dir.x * SPEED
	move_and_slide()

func take_damage(amount: int) -> void:
	_health -= amount
	# instantiate blood particle effect
	var blood := take_damage_particle.instantiate()
	add_child(blood)
	blood.emitting = true # manually turn on emitting since blood is a oneshot.
	if _health <= 0:
		_health = 0
		queue_free()
