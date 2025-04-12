class_name Gate extends StaticBody2D

@export var begin_open: bool = true
@export var open_collider_height: float
@export var closed_collider_height: float
@export var open_collider_pos_y: float
@export var closed_collider_pos_y: float

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var _is_open: bool

func _ready() -> void:
	_is_open = begin_open
	if _is_open:
		open()
		#animated_sprite_2d.play("open")
		#animated_sprite_2d.set_frame_and_progress(4, 1.0)
	else:
		close()
		#animated_sprite_2d.play("close")
		#animated_sprite_2d.set_frame_and_progress(4, 1.0)

func open() -> void:
	_is_open = true
	animated_sprite_2d.play("open")
	collision_shape_2d.shape.size.y = open_collider_height
	collision_shape_2d.position.y = open_collider_pos_y
	
func is_open() -> bool:
	return _is_open

func close() -> void:
	_is_open = false
	animated_sprite_2d.play("close")
	collision_shape_2d.shape.size.y = closed_collider_height
	collision_shape_2d.position.y = closed_collider_pos_y
