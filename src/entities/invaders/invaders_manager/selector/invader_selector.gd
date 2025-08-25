@tool
class_name InvaderSelector
extends Node2D

enum Direction {
	LEFT,
	RIGHT
}

var start: Vector2 = Vector2(0, 0)

var row_width: float = 0
var row_idx_offset: float = 0

var strafe_speed: float = 50
var strafe_steps: int = 2
var current_step: int = 0
var current_direction: Direction = Direction.RIGHT
var drop_speed: float = 50

var selected_column: int = 0

var show_rect: bool = false

func _ready() -> void:
	Clock.subscribe(self)

func _process(_delta: float) -> void:
	if !self.show_rect:
		return

	# If I'm not too lazy I should check for changes before calling this.
	queue_redraw()

func _draw() -> void:
	var rect := Rect2(
		Vector2(start.x + self.selected_column * row_idx_offset,
				start.y),
		Vector2(row_width, 660),
	)
	draw_rect(rect, Color(0, 1, 0, 1.0), false, 4.0)

func tick() -> void:
	if self.current_direction == Direction.RIGHT and current_step >= strafe_steps:
		self.current_direction = Direction.LEFT
		start.y += drop_speed
		return
	if self.current_direction == Direction.LEFT and current_step <= 0:
		self.current_direction = Direction.RIGHT
		start.y += drop_speed
		return

	match current_direction:
		Direction.RIGHT:
			current_step += 1
			start.x += strafe_speed
		Direction.LEFT:
			current_step -= 1
			start.x -= strafe_speed

func set_show_rect() -> void:
	self.show_rect = true

func set_hide_rect() -> void:
	self.show_rect = false
