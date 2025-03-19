class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var slash: Area2D = $Slash
@onready var slash_sprite: Sprite2D = $Slash/SlashSprite

const EXTRA_JUMP_AMMOUNT = 1

var _enable_extra_jump := false
var _extra_jump_counter := 0
var _enable_dash := true

func _init() -> void:
	Game.set_player(self)
	enable_extra_jump()

func _ready() -> void:
	slash_sprite.visible = false

func _process(delta: float) -> void:
	slash.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("attack"):
		slash_sprite.visible = true
		for enemy: Enemy in slash.get_overlapping_bodies():
			enemy.take_damage(30)
		
		await get_tree().create_timer(0.05).timeout
		slash_sprite.visible = false

func enable_extra_jump() -> void:
	_enable_extra_jump = true
	_extra_jump_counter = EXTRA_JUMP_AMMOUNT

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and (is_on_floor() or _extra_jump_counter > 0):
		velocity.y = JUMP_VELOCITY
		if is_on_floor() and _enable_extra_jump:
			_extra_jump_counter = EXTRA_JUMP_AMMOUNT
		else:
			_extra_jump_counter -= 1;

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("move_dash"):
		velocity.x *= 40
		velocity.y *= 2
		

	move_and_slide()
