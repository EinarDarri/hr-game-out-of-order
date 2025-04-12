extends Node

@export_category("Prompts")
@export var PC_light: Sprite2D
@export var PC_dark: Sprite2D
@export var PS5: Sprite2D
@export var STEAM_deack: Sprite2D
@export var Xbox: Sprite2D

func _ready() -> void:
	_hide_all()
	_update_prompt()

func _hide_all() -> void:
	PC_light.visible = false
	PC_dark.visible = false
	PS5.visible = false
	STEAM_deack.visible = false
	Xbox.visible = false

func _update_prompt() -> void:
	_hide_all()
	var controler_type = Input.get_joy_name(0)
	if controler_type == null:
		controler_type = ""
	
	if "PS" in controler_type:
		PS5.visible = true
		
	elif "Steam" in controler_type:
		STEAM_deack.visible = true
		
	elif "Xbox" in controler_type:
		Xbox.visible = true
		
	else:
		if Game.LightMode:
			PC_light.visible = true
		else:
			PC_dark.visible = true 
	
