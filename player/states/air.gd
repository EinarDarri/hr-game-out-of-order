extends PlayerState

@onready var timer: Timer = $Timer

@export_category("States")
@export var idle_state: PlayerState
@export var running_state: PlayerState
@export var attacking_state: PlayerState

const JUMP_VELOCITY = -350.0
const EXTRA_JUMP_AMOUNT = 1
const COYOTE_TIME = 0.05

var _coyote_flag := true
var extra_jump_counter := 0

func start_state() -> void:
	player.animated_sprite_2d.play("Jump")
	if player.is_on_floor() and player.is_extra_jump_enabled():
		extra_jump_counter = EXTRA_JUMP_AMOUNT
		
	if Input.is_action_just_pressed("move_jump"):
		player.velocity.y = JUMP_VELOCITY
		return
	else:
		timer.start(COYOTE_TIME)
		_coyote_flag = true


func update_state(delta):
	if Input.is_action_just_pressed("move_jump"):
		if _coyote_flag:
			player.velocity.y = JUMP_VELOCITY
			return
		elif extra_jump_counter > 0:
			extra_jump_counter -= 1
			player.velocity.y = JUMP_VELOCITY
			return
			
	if Input.is_action_just_pressed("attack"):
		stateman.active_state = attacking_state
		return
	
	
	# so the player can fine tune there movement while in the air
	player.velocity.x = move_toward(player.velocity.x, player.get_movement_dir().x * player.SPEED, delta*player.SPEED*4)
	
	# Add the gravity. 
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	else:
		if player.get_movement_dir().x == 0:
			stateman.active_state = idle_state
		else:
			stateman.active_state = running_state
		return

func end_state() -> void:
	player.animated_sprite_2d.stop()

func _on_timer_timeout() -> void:
	_coyote_flag = false
