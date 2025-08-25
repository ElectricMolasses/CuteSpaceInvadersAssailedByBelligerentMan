class_name BelligerentMan
extends Node2D

enum Action {
	IDLE,
	MOVE_LEFT,
	MOVE_RIGHT,
	FIRE,
}

## The size of the player.
@export var size: int = 64

## The number of "steps" the `BelligerentMan` is allowed to take
##  in either direction.
@export var allowed_steps: int = 3

var current_step: int = 0

## The size the player is coded for, before scaling to match
##  the editor defined size
var base_player_size = 64

var current_action: Action = Action.IDLE

## Track whether or not the last fired projectile still exists.
##  Similar to space invaders, the enemy cannot have multiple
##  projectiles in play at once.
var projectile_exists: bool = false

var projectile_manager = ProjectileManager
var projectile_spawner: ProjectileSpawner

func _ready() -> void:
	projectile_spawner = $ProjectileSpawner

func tick() -> void:
	match current_action:
		Action.IDLE:
			pass
		Action.MOVE_LEFT:
			move(current_action)
		Action.MOVE_RIGHT:
			move(current_action)
		Action.FIRE:
			fire()

## Accepts an action (Assumed to be one of the two
##  move actions, godot doesn't support enum
##  inheritance), and moves in the direction if
##  not at the step boundary, while moving in the
##  opposite direction if it is at the step boundary.
##  This both prevents the `BelligerentMan` from
##  leaving the confines of the game, as well as
##  preventing the odds of movement vs IDLE or
##  FIRE from changing at the boundary.
func move(action: Action) -> void:
	match action:
		Action.MOVE_LEFT:
			if current_step <= -allowed_steps:
				self.move_right()
				return
			self.move_left()
		Action.MOVE_RIGHT:
			if current_step >= allowed_steps:
				self.move_left()
				return
			self.move_right()

func move_right() -> void:
	self.position.x += 50
	self.current_step += 1

func move_left() -> void:
	self.position.x -= 50
	self.current_step -= 1

## Call into the attached `ProjectileSpawner` to create a projectile.
##  This allows us to decouple firing logic from the `BelligerentMan`,
##  as well as easily and visually move the location projectiles
##  will spawn at, relative to the `BelligerentMan`.
func fire() -> void:
	projectile_spawner.spawn_enemy_projectile(self.position)

func kill() -> void:
	queue_free()
