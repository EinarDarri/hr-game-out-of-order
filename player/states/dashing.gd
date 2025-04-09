class_name PlayerDashState extends PlayerState

const SPEED: Vector2 = Vector2(350.0*2,350.0*2)

var previus_state: PlayerState

func start_state() -> void:
	var movdir := player.get_movement_dir()
	var speed := movdir * SPEED
	player.velocity += speed

func update_state(_delta: float) -> void:
	stateman.active_state = previus_state

func physics_update(_delta: float) -> void:
	pass

func end_state() -> void:
	pass

func attack_received(_attack: Attack) -> void:
	pass
