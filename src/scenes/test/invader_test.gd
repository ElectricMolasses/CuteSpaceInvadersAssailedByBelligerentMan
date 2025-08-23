extends Node2D

var test_invader: Invader = null

@export var frame_length: float = 0.5

var current_frame_time: float = 0.0


func _ready() -> void:
	test_invader = $Invader

func _physics_process(delta: float) -> void:
	self.current_frame_time += delta

	if self.current_frame_time >= self.frame_length:
		self.current_frame_time -= self.frame_length
		test_invader.tick()
