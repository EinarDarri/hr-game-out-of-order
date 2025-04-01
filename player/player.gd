class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const EXTRA_JUMP_AMOUNT = 1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_animation_timer: Timer = $AttackAnimationTimer
@onready var slash: Area2D = $LookDirection/Slash
@onready var slash_sprite: Sprite2D = $LookDirection/Slash/SlashSprite
@onready var _dash_timer: Timer = $DashTimer
@onready var state_man: StateManager = $StateMan

var _player_movement:Vector2 = Vector2.ZERO:
	set(new_vec):
		if new_vec.x != 0:
			animated_sprite_2d.flip_h = _player_movement.x < 0
		
		_player_movement = new_vec

# Extra jump and dash variables
var _enable_extra_jump := false
var extra_jump_counter := 0
var _enable_dash := false
var _can_dash := true
var attack_buffered := false
var jump_buffered := false
var dash_buffered := false


func _init() -> void:
	Game.set_player(self)
	enable_extra_jump()
	enable_dash()

func _ready() -> void:
	animated_sprite_2d.play("Idle")

func _process(delta: float) -> void:
	_player_movement = Vector2(
		Input.get_axis("move_left", "move_right"),
		-Input.get_axis("look_down","look_up")
	).normalized()
	
	
	
	
	if Input.is_action_just_pressed("attack"):
		attack_buffered = true
		
	if Input.is_action_just_pressed("move_jump"):
		jump_buffered = true
		
	if Input.is_action_just_pressed("move_dash"):
		dash_buffered = true
	
	if attack_buffered and attack_timer.time_left == 0:
		animated_sprite_2d.play("Slash")
		animated_sprite_2d.frame = 0
		attack_timer.start()
		attack_animation_timer.start()
		attack_buffered = false
		
		for enemy: Enemy in slash.get_overlapping_bodies():
			enemy.take_damage(30)
		
		await get_tree().create_timer(0.05).timeout

func enable_extra_jump() -> void:
	_enable_extra_jump = true
	extra_jump_counter = EXTRA_JUMP_AMOUNT

func enable_dash() -> void:
	_enable_dash = true
	
func get_movement_dir() -> Vector2:
	return _player_movement
	
func get_jump() -> bool:
	return jump_buffered
	
func can_jump() -> bool:
	return (is_on_floor() or extra_jump_counter > 0)
	
func get_dash() -> bool:
	return dash_buffered
	
func can_dash() -> bool:
	return _enable_dash and _can_dash

func _physics_process(delta: float) -> void:
	if attack_timer.time_left > 0:
		velocity = Vector2.ZERO
		return

	# Add the gravity. 
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	state_man.active_state.update_state(delta)
	
	dash_buffered = false
	jump_buffered = false
	attack_buffered = false
		
	if dash_buffered and _enable_dash and _can_dash:
		velocity.x *= 40
		velocity.y = -JUMP_VELOCITY * _player_movement.y * 2
		print(velocity.y)
		_can_dash = false
		_dash_timer.start()
		dash_buffered = false

	move_and_slide()


func _on_dash_timer_timeout() -> void:
	_can_dash = true
	print("Can dash")
