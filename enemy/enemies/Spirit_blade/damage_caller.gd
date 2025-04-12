extends Node

@export var particles: GPUParticles2D

func emit_particles() -> void:
	particles.restart()
	print_debug("Emitting")
