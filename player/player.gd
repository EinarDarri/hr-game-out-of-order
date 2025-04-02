class_name Player extends CharacterBody2D

const SPEED = 300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
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
var _enable_dash := false
var _can_dash := true

var _health := 100
var _max_health := 100

func get_health() -> int:
	return _health

func get_max_health() -> int:
	return _max_health

func _init() -> void:
	Game.set_player(self)
	enable_extra_jump()
	# enable_dash()

func _ready() -> void:
	animated_sprite_2d.play("Idle")

func _process(_delta: float) -> void:
	_player_movement = Vector2(
		Input.get_axis("move_left", "move_right"),
		-Input.get_axis("look_down","look_up")
	).normalized()
	
func get_facing() -> int:
	return -1 if animated_sprite_2d.flip_h else 1
	
func enable_extra_jump() -> void:
	_enable_extra_jump = true
	
func is_extra_jump_enabled() -> bool:
	return _enable_extra_jump

func enable_dash() -> void:
	_enable_dash = true

func is_dash_enabled() -> bool:
	return _enable_dash
	
func get_movement_dir() -> Vector2:
	return _player_movement
	
func can_dash() -> bool:
	return _enable_dash and _can_dash

func _physics_process(delta: float) -> void:
	state_man.active_state.update_state(delta)
		
	#if dash_buffered and _enable_dash and _can_dash:
		#velocity.x *= 40
		#velocity.y = -JUMP_VELOCITY * _player_movement.y * 2
		#print(velocity.y)
		#_can_dash = false
		#_dash_timer.start()
		#dash_buffered = false

	move_and_slide()


func _on_dash_timer_timeout() -> void:
	_can_dash = true
	print("Can dash")
