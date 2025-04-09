class_name Enemy extends CharacterBody2D

@export var movement_speed: float = 10.0
@export var max_health: int = 100
@export var take_damage_particle: PackedScene
@export var death_effect_scene: PackedScene
@onready var hit_sfx: AudioStreamPlayer = $HitSFX

var _health: int
var _max_health:int
var _target_velocity: Vector2
var _can_attack: bool = true

signal attack_received(attack: Attack)

func _ready() -> void:
	_health = max_health
	
func get_health() -> int:
	return _health

func get_max_health() -> int:
	return _max_health
	
func take_damage(attack: Attack) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	move_and_slide()	
	
