class_name InvaderManager
extends Node2D

## The number of columns to fill with invaders
@export var columns: int = 1
## The number of rows to fill with invaders
@export var rows: int = 1

## The space between each invader in a row
@export var row_gap: float = 60
## The space between each invader in a column
@export var column_gap: float = 60

## The width of an invader
@export var invader_width: float = 60
## The height of an invader
@export var invader_height: float = 60

## The width that the invader is allowed to strafe within
@export var invader_strafe_width: float = 180

## The length of a frame in seconds
@export var frame_length: float = 0.5

var current_frame_time: float = 0.0

## The Invader scene that the manager should load
##  to generate Invader instances from
@export var invader_scene: PackedScene

var invaders: Array[Invader] = []


func _ready() -> void:
	self.create_invaders()

func _physics_process(delta: float) -> void:
	self.current_frame_time += delta
	if self.current_frame_time >= self.frame_length:
		self.current_frame_time -= self.frame_length
		self.tick()

func create_invaders() -> void:
	var current_position: Vector2 = self.position
	for i in range(0, rows):
		for j in range(0, columns):
			var new_invader: Invader = invader_scene.instantiate()
			new_invader.position = current_position
			new_invader.strafe_box = Rect2(Vector2(0, 0), 
										   Vector2(invader_strafe_width, 0))

			add_child(new_invader)
			self.invaders.push_back(new_invader)

			current_position.x += invader_width + column_gap
		current_position.x = self.position.x
		current_position.y += invader_height + row_gap

func tick() -> void:
	for invader in self.invaders:
		invader.tick()
