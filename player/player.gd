class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var slash: Area2D = $Slash
@onready var slash_sprite: Sprite2D = $Slash/SlashSprite

func _init() -> void:
	Game.set_player(self)

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

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
