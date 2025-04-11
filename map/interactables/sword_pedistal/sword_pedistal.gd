extends AnimatedSprite2D

@onready var interact_area: Area2D = $InteractArea
@onready var interact_prompt: Label = $InteractPrompt
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var pickup_sfx: AudioStreamPlayer = $PickupSFX
@onready var point_light_2d: PointLight2D = $PointLight2D

var _picked_up := false

func _ready() -> void:
	play("default")

func _process(delta: float) -> void:
	var interactable = interact_area.has_overlapping_bodies() and not _picked_up
	interact_prompt.visible = interactable
	if interactable and Input.is_action_just_pressed("interact"):
		pickup()

func pickup():
	point_light_2d.enabled = false
	Music.play()
	play("inactive")
	pickup_sfx.play()
	gpu_particles_2d.emitting = true
	Game.get_player().has_sword = true
	_picked_up = true
