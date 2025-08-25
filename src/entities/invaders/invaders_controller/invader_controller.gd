extends Node2D


@export var invaders_manager: InvaderManager

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LEFT"):
		invaders_manager.selection_to_left()
	if Input.is_action_just_pressed("RIGHT"):
		invaders_manager.selection_to_right()
	if Input.is_action_just_pressed("TRIGGER"):
		invaders_manager.flag_fire()
