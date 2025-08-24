extends Node2D

@export var test_target_projectile: Node

@export var frame_length: float = 0.5
var current_frame_time: float = 0.0

func _physics_process(delta: float) -> void:
	current_frame_time += delta

	if current_frame_time >= frame_length:
		current_frame_time -= frame_length
		test_target_projectile.tick()
