extends Node2D

@export var puppet: BelligerentMan

func _ready() -> void:
	Clock.subscribe(self)

func tick() -> void:
	puppet.current_action = pick_next_action()
	puppet.tick()

func pick_next_action() -> BelligerentMan.Action:
	var action_value = randi() % BelligerentMan.Action.size()

	return action_value as BelligerentMan.Action
