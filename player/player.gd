class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_animation_timer: Timer = $AttackAnimationTimer
@onready var slash: Area2D = $LookDirection/Slash
@onready var slash_sprite: Sprite2D = $LookDirection/Slash/SlashSprite
@onready var _dash_timer: Timer = $DashTimer
@onready var state_man: StateManager = $StateMan

var _player_movement:Vector2 = Vector2.ZERO

# Extra jump and dash variables
const EXTRA_JUMP_AMOUNT = 1
var _enable_extra_jump := false
var _extra_jump_counter := 0
var _enable_dash := false
var _can_dash := true
var _attack_buffered := false
var _jump_buffered := false
var _dash_buffered := false


func _init() -> void:
	Game.set_player(self)
	enable_extra_jump()
	# enable_dash()

func _ready() -> void:
	animated_sprite_2d.play("Idle")

func _process(delta: float) -> void:
	_player_movement = Vector2(
		Input.get_axis("move_left", "move_right"),
		-Input.get_axis("look_down","look_up")
	).normalized()
	
	
	if Input.is_action_just_pressed("attack"):
		_attack_buffered = true
		
	if Input.is_action_just_pressed("move_jump"):
		_jump_buffered = true
		
	if Input.is_action_just_pressed("move_dash"):
		_dash_buffered = true
	
	if _attack_buffered and attack_timer.time_left == 0:
		animated_sprite_2d.play("Slash")
		attack_timer.start()
		attack_animation_timer.start()
		_attack_buffered = false
		
		for enemy: Enemy in slash.get_overlapping_bodies():
			enemy.take_damage(30)
		
		await get_tree().create_timer(0.05).timeout

func enable_extra_jump() -> void:
	_enable_extra_jump = true
	_extra_jump_counter = EXTRA_JUMP_AMOUNT

func enable_dash() -> void:
	_enable_dash = true
	
func get_movement_dir() -> Vector2:
	return _player_movement


func _physics_process(delta: float) -> void:
	if attack_timer.time_left > 0:
		velocity = Vector2.ZERO
		return

	# Add the gravity. 
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if _jump_buffered and (is_on_floor() or _extra_jump_counter > 0):
		animated_sprite_2d.play("Jump")
		velocity.y = JUMP_VELOCITY
		if is_on_floor() and _enable_extra_jump:
			_extra_jump_counter = EXTRA_JUMP_AMOUNT
		else:
			_extra_jump_counter -= 1;
		
		_jump_buffered = false

	var direction := _player_movement.x
	if direction:
		if is_on_floor() and attack_animation_timer.time_left == 0:
			animated_sprite_2d.play("Running")
		velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = direction < 0
	else:
		if is_on_floor() and attack_animation_timer.time_left == 0:
			animated_sprite_2d.play("Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if _dash_buffered and _enable_dash and _can_dash:
		velocity.x *= 40
		velocity.y = -JUMP_VELOCITY * _player_movement.y * 2
		print(velocity.y)
		_can_dash = false
		_dash_timer.start()
		_dash_buffered = false

	move_and_slide()


func _on_dash_timer_timeout() -> void:
	_can_dash = true
	print("Can dash")
