class_name Enemy extends CharacterBody2D

@export var movement_speed: float = 10.0
@export var max_health: int = 100
@export var take_damage_particle: PackedScene
@export var death_effect_scene: PackedScene
@onready var hit_sfx: AudioStreamPlayer = $HitSFX

var _health: int
var _target_velocity: Vector2
var _can_attack: bool = true
var _last_attack_received: Attack

signal attack_received(attack: Attack)
## Signal to tell the spawner that one of the enemies that it spawned in was killed
signal Died

func _ready() -> void:
	_health = max_health
	
func get_health() -> int:
	return _health

func get_max_health() -> int:
	return max_health
	
func take_damage(attack: Attack) -> void:
	print_debug("Damage taken: ", attack.damage)
	_last_attack_received = attack
	_health = clamp(_health - attack.damage, 0, max_health)
	attack_received.emit(attack)
	if _health == 0:
		Died.emit()
		queue_free()
	
func _physics_process(delta: float) -> void:
	move_and_slide()

func get_last_attack_received() -> Attack:
	return _last_attack_received
