@tool
extends Node2D

@export var target_node: Invader = null
@export var strafe_box_fill: Color = Color(0.1, 0.8, 0.1, 0.5)
@export var strafe_box_stroke: Color = Color(0.1, 0.95, 0.1, 0.8)
@export var strafe_box_stroke_width: float = 2.0

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(true)
		queue_redraw()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _set_target_node(target: Node2D) -> void:
	self.target_node = target

func _draw():
	if !Engine.is_editor_hint():
		return
	if !target_node:
		return

	var strafe_box: Rect2 = target_node.strafe_box
	strafe_box.position += target_node.position

	draw_rect(strafe_box, strafe_box_fill, true)
