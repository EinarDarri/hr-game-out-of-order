extends Node2D

@onready var interact_area: Area2D = $InteractArea
@onready var interact_prompt: Node2D = $Prompts
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var activate_sfx: AudioStreamPlayer = $ActivateSFX

var _active := false

func _process(delta: float) -> void:
	_active = Game.get_player().respawn_point == global_position
	
	if not _active and animated_sprite_2d.animation == &"active":
		animated_sprite_2d.play("default")
	
	var interactable = interact_area.has_overlapping_bodies() and not _active
	
	interact_prompt.visible = interactable
	if interactable and Input.is_action_just_pressed("interact"):
		activate()

func activate():
	Game.get_player().respawn_point = global_position
	animated_sprite_2d.play("activate")
	activate_sfx.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	gpu_particles_2d.emitting = true
	animated_sprite_2d.play("active")
