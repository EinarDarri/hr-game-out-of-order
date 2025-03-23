class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_animation_timer: Timer = $AttackAnimationTimer

@onready var slash: Area2D = $Slash

var attack_buffered = false

func _init() -> void:
	Game.set_player(self)

func _ready() -> void:
	animated_sprite_2d.play("Idle")

func _process(delta: float) -> void:
	slash.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("attack"):
		attack_buffered = true
	
	if attack_buffered and attack_timer.time_left == 0:
		animated_sprite_2d.play("Slash")
		animated_sprite_2d.frame = 0
		attack_timer.start()
		attack_animation_timer.start()
		attack_buffered = false
		
		for enemy: Enemy in slash.get_overlapping_bodies():
			enemy.take_damage(30)
		
		await get_tree().create_timer(0.05).timeout

func _physics_process(delta: float) -> void:
	
	if attack_timer.time_left > 0:
		velocity = Vector2.ZERO
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			if is_on_floor() and attack_animation_timer.time_left == 0:
				animated_sprite_2d.play("Running")
			velocity.x = direction * SPEED
			animated_sprite_2d.flip_h = direction < 0
		else:
			if is_on_floor() and attack_animation_timer.time_left == 0:
				animated_sprite_2d.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		# Handle jump.
		if Input.is_action_just_pressed("move_jump") and is_on_floor():
			animated_sprite_2d.play("Jump")
			velocity.y = JUMP_VELOCITY

	move_and_slide()
