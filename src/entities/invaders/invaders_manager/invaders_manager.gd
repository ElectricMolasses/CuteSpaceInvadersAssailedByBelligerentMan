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
var selector_handler: InvaderSelector

var invaders: Array[Invader] = []

var selected_column: int = 0

## Variable to track whether an invader has been selected to fire,
##  and if so, which one.
var fire_next_frame: int = -1


func _ready() -> void:
	self.create_invaders()
	self.selector_handler = $InvaderSelector
	self.selector_handler.start = self.position
	self.selector_handler.show_rect = true
	self.selector_handler.row_width = invader_width
	self.selector_handler.row_idx_offset = invader_width + column_gap
	self.selector_handler.strafe_speed = 50
	Clock.subscribe(self)

func _process(_delta: float) -> void:
	self.selector_handler.selected_column = self.selected_column

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
	for i in len(self.invaders):
		if self.invaders[i]:
			self.invaders[i].tick()
	
	if fire_next_frame != -1:
		# Get applicable invaders to fire
		var applicable_invaders: Array[Invader] = []
		for i in range(selected_column, len(invaders), columns):
			applicable_invaders.push_front(invaders[i])

		for invader in applicable_invaders:
			if invader:
				invader.fire()
				break

		fire_next_frame = -1


func get_selection() -> int:
	return self.selected_column

func selection_to_right() -> int:
	self.selected_column += 1
	self.selected_column = min(selected_column, columns-1)

	return self.selected_column

func selection_to_left() -> int:
	self.selected_column -= 1
	self.selected_column = max(selected_column, 0)

	return self.selected_column

func flag_fire() -> void:
	self.fire_next_frame = self.selected_column
