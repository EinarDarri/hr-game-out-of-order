class_name Enemy extends CharacterBody2D

const SPEED = 100.0

var _health: int = 100
var _max_health: int = 100
var _target_velocity: Vector2

@export var take_damage_particle: PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_sfx: AudioStreamPlayer = $HitSFX

const DEATH = preload("res://enemy/death.wav")

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
	_target_velocity.x = dir.x * SPEED
	
	velocity = velocity.move_toward(_target_velocity, delta * 100)
	
	move_and_slide()

func take_damage(attack: Attack) -> void:
	_health -= attack.damage
	velocity += attack.knockback
	# instantiate blood particle effect
	var blood := take_damage_particle.instantiate()
	add_child(blood)
	blood.emitting = true # manually turn on emitting since blood is a oneshot.
	if _health <= 0:
		_health = 0
		get_tree().root.add_child(SfxOneOff.new(DEATH, -10.0))
		queue_free()
		return
	
	hit_sfx.pitch_scale = randf_range(0.9, 1.1)
	hit_sfx.play()
	
	sprite_2d.material.set_shader_parameter("flash", true)
	get_tree().paused = true
	await get_tree().create_timer(0.05).timeout
	sprite_2d.material.set_shader_parameter("flash", false)
	get_tree().paused = false
	
	await get_tree().create_timer(0.05).timeout
	sprite_2d.material.set_shader_parameter("flash", true)
	await get_tree().create_timer(0.05).timeout
	sprite_2d.material.set_shader_parameter("flash", false)
	
