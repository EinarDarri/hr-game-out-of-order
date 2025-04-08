class_name EnemyOld extends CharacterBody2D

const SPEED = 100.0

var _health: int = 100
var _max_health: int = 100
var _target_velocity: Vector2
var _can_attack: bool = true

@export var take_damage_particle: PackedScene
@export var death_effect_scene: PackedScene
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_sfx: AudioStreamPlayer = $HitSFX
@onready var attack_area: Area2D = $AttackArea
@onready var attack_cooldown: Timer = $AttackCooldown

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
	
	if _can_attack:
		_attack()

func _attack():
	for player in attack_area.get_overlapping_bodies():
		var attack = Attack.new()
		attack.damage = 12
		attack.knockback = (player.global_position - global_position).normalized() * 700 + Vector2.UP * 700
		
		player.take_damage(attack)
		_can_attack = false
		attack_cooldown.start()

func take_damage(attack: Attack) -> void:
	_health -= attack.damage
	velocity += attack.knockback
	# instantiate blood particle effect
	var blood := take_damage_particle.instantiate()
	add_child(blood)
	blood.emitting = true # manually turn on emitting since blood is a oneshot.
	if _health <= 0:
		_health = 0
		
		var death_effect := death_effect_scene.instantiate() # needs to be fixed i think this is spawning at 0,0?
		get_tree().root.add_child(death_effect)
		death_effect.global_position = global_position
		
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


func _on_attack_cooldown_timeout() -> void:
	_can_attack = true
