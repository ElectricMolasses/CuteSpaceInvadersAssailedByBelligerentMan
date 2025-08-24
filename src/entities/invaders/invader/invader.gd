class_name Invader
extends Node2D

enum Direction {
	LEFT,
	RIGHT,
}

enum Position {
	LEFT,
	# Center removed for simplicity,
	RIGHT,
}

## The period of time, in seconds that each frame should last.
@export var frame_length: float = 0.5

## The number of units to the left or right that the invader
##  moves each `tick`.
@export var strafe_speed: float = 50

## The number of units downwards that the invader falls each
##  time they reach either edge of their strafe box.
@export var drop_speed: float = 50

## The direction the invader is set to move in on the first tick.
@export var start_direction: Direction = Direction.RIGHT

## The position the invader is set to start at within its strafe
##  box.
@export var start_position: Position = Position.LEFT

var current_direction: Direction = start_direction
var current_frame_time: float = 0.0

var sprite: Sprite2D = null
var visual_width: float = 0.0

## A rectangle used to visually define the bounding box for the
##  invaders vertical movement.
@export var strafe_box: Rect2 = Rect2(Vector2(0, 0), Vector2(0, 60))
var strafe_left_x: float = 0.0
var strafe_right_x: float = 0.0

func _ready() -> void:
	strafe_left_x =  self.position.x
	strafe_right_x = self.position.x + strafe_box.size.x

	self.sprite = $Sprite
	self.visual_width = self.sprite.texture.get_size().x
	self.visual_width *= self.sprite.scale.x

	# Place the invader in the correct location of its box. Assume
	#  that the editor placement of the invader represents the left
	#  edge of the invaders strafe box.
	match start_position:
		Position.LEFT:
			# The invader is starting at the correct location already
			pass
		Position.RIGHT:
			position.x += strafe_box.size.x - self.visual_width

func _physics_process(delta: float) -> void:
	pass

func tick() -> void:
	self.handle_movement()

func handle_movement() -> void:
	var move_vector = Vector2(strafe_speed, 0)
	if current_direction == Direction.LEFT:
		move_vector = -move_vector
	
	var new_position = self.position + move_vector

	if new_position.x > strafe_right_x - self.visual_width:
		self.position.y += self.drop_speed
		self.current_direction = Direction.LEFT
	elif new_position.x < strafe_left_x:
		self.position.y += self.drop_speed
		self.current_direction = Direction.RIGHT
	else:
		self.position = new_position
