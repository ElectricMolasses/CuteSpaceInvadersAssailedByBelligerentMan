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

@export var strafe_box: Rect2 = Rect2(self.position, Vector2(0, 0))
var strafe_left_x: float = 0.0
var strafe_right_x: float = 0.0

var is_dropping: bool = false

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

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func tick() -> void:
	self.handle_movement()

func handle_movement() -> void:
	if is_dropping:
		self.position.y += self.drop_speed
		self.is_dropping = false
		return

	var move_vector = Vector2(strafe_speed, 0)
	if current_direction == Direction.LEFT:
		move_vector = -move_vector
	
	self.position += move_vector

	if self.position.x >= strafe_right_x - self.visual_width:
		self.current_direction = Direction.LEFT
		self.is_dropping = true
	elif self.position.x <= strafe_left_x:
		self.current_direction = Direction.RIGHT
		self.is_dropping = true
	
	self.clamp_to_strafe_box()

func clamp_to_strafe_box() -> void:
	self.position.x = clamp(self.position.x, strafe_left_x, strafe_right_x - visual_width)
