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

func move(action: Action) -> void:
	match action:
		Action.MOVE_LEFT:
			self.position.x -= 60
		Action.MOVE_RIGHT:
			self.position.x += 60

func fire() -> void:
	projectile_spawner.spawn_enemy_projectile(self.position)

