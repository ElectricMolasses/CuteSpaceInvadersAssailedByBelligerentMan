extends Node2D

@export var puppet: BelligerentMan

func _ready() -> void:
	Clock.subscribe(self)

func tick() -> void:
	puppet.current_action = pick_next_action()
	puppet.tick()

## Randomly pick one of any of `BelligerentMan`'s actions,
##  then return that action. This allows us to add actions
##  to `BelligerentMan` in the future and they'll be added
##  to the randomly selectable options as long as they
##  follow the pattern and exist in the `Action` enum
func pick_next_action() -> BelligerentMan.Action:
	var action_value = randi() % BelligerentMan.Action.size()

	return action_value as BelligerentMan.Action
