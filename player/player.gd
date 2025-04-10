class_name Player extends CharacterBody2D

const DEAD_ZONE = .2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var slash: Area2D = $LookDirection/Slash
@onready var _dash_timer: Timer = $DashTimer
@onready var state_man: StateManager = $StateMan
@onready var hit_sfx: AudioStreamPlayer = $HitSFX

var respawn_point := Vector2.ZERO

signal attack_received(attack: Attack)

var _player_movement: Vector2 = Vector2.ZERO:
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
	enable_dash()

func _ready() -> void:
	animated_sprite_2d.play("Idle")
	Dialogic.start('game_start')

func _input(event: InputEvent) -> void:
	# Toggle debug mode
	if event is InputEventKey and event.pressed and event.keycode == KEY_F1:
		Debug.enabled = not Debug.enabled

func _process(_delta: float) -> void:
	var x:float = Input.get_axis("move_left", "move_right")
	var y:float = -Input.get_axis("look_down","look_up")
	_player_movement = Vector2(
		0 if abs(x) <= DEAD_ZONE else x,
		0 if abs(y) <= DEAD_ZONE else y
	).normalized()
	
	if not can_control():
		_player_movement = Vector2.ZERO
	
	if Debug.enabled:
		ImGui.Begin("Player Info")
		ImGui.Text("Velocity: %.1f, %.1f" % [velocity.x, velocity.y])
		ImGui.Text("Input: %.1f, %.1f" % [_player_movement.x, _player_movement.y])
		ImGui.Text("Health: %d / %d" % [_health, _max_health])
		ImGui.Text("Respawn: %.1f, %.1f" % [respawn_point.x, respawn_point.y])
		ImGui.Separator()
		state_man.gui()
		ImGui.End()

func take_damage(attack: Attack) -> void:
	attack_received.emit(attack)

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

func can_control() -> bool:
	return Dialogic.current_timeline == null

func _physics_process(delta: float) -> void:
	move_and_slide()

func apply_damage(amount: int) -> void:
	_health = max(_health - amount, 0)
	
	if _health == 0:
		_health = _max_health
		global_position = respawn_point
		velocity = Vector2.ZERO

func _on_dash_timer_timeout() -> void:
	_can_dash = true
