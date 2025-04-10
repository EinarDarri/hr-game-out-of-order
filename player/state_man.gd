class_name StateManager extends Node

@onready var player: Player = $".."

@export var active_state: PlayerState:
	set(new_state):
		if not new_state.can_enter():
			return
		
		if active_state != null:
			active_state.end_state()
			new_state.start_state()
		active_state = new_state

func _ready() -> void:
	player.attack_received.connect(_attack_received)

func _process(delta: float) -> void:
	active_state.update_state(delta)

func gui() -> void:
	ImGui.Text("Active State: %s" % active_state.name)
	ImGui.Separator()
	active_state.gui()

func _physics_process(delta: float) -> void:
	active_state.physics_update(delta)

func _attack_received(attack: Attack) -> void:
	active_state.attack_received(attack)
