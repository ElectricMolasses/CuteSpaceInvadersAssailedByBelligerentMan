extends Node

@export var frame_length: float = 0.5
var current_frame_time: float = 0.0

var subscribers: Array = []

func _physics_process(delta: float) -> void:
	current_frame_time += delta

	if current_frame_time >= frame_length:
		current_frame_time -= frame_length
		for subscriber in subscribers:
			if subscriber:
				subscriber.tick()

func subscribe(ref: Variant) -> void:
	subscribers.push_back(ref)
