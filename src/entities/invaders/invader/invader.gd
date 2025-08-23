class_name Invader
extends Node2D

enum Direction {
	LEFT,
	RIGHT,
}

enum Position {
	LEFT,
	CENTER,
	RIGHT,
}

## The period of time, in seconds that each frame should last.
@export var frame_length: float = 0.5

## Dictates the width of the box defining the area the invader 
##  will strafe horizontally within.
@export var strafe_width: float = 200

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

@export var strafe_box: Rect2 = Rect2(self.position, Vector2(strafe_width, 0))

func _ready() -> void:
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
		#TODO: These two need to have the sprites width removed from strafe_width.
		Position.CENTER:
			position.x += (strafe_width - (self.visual_width / 2)) / 2
		Position.RIGHT:
			position.x += strafe_width - (self.visual_width / 2)

func _process(delta: float) -> void:
	current_frame_time += delta

	if current_frame_time >= frame_length:
		current_frame_time -= frame_length
		self.tick()

func _physics_process(delta: float) -> void:
	pass

func tick() -> void:
	var move_vector = Vector2(strafe_speed, 0)
	if current_direction == Direction.LEFT:
		move_vector *= -1
	self.position += move_vector

	if self.position.x >= strafe_box.end.x:
		self.current_direction = Direction.LEFT
		self.position.y += self.drop_speed
	elif self.position.x <= strafe_box.position.x:
		self.current_direction = Direction.RIGHT
		self.position.y += self.drop_speed
	
	self.clamp_to_strafe_box()

func clamp_to_strafe_box() -> void:
	self.position.x = clamp(self.position.x, strafe_box.position.x, strafe_box.end.x)

func _draw_strafe_box() -> void:
	if !Engine.is_editor_hint():
		return

	var box: Rect2 = Rect2(self.position, Vector2(self.strafe_width, 100))
	draw_rect(box, Color(1, 0, 0, 1), true)
