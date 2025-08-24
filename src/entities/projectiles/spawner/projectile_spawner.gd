class_name ProjectileSpawner
extends Node2D

enum Type {
	ENEMY,
	INVADER,
}

var projectile_manager

@export var projectile: PackedScene
@export var type: Type = Type.INVADER

func _ready() -> void:
	projectile_manager = ProjectileManager

func spawn_enemy_projectile(position: Vector2) -> void:
	projectile_manager.spawn_enemy_projectile(position + self.position, projectile)

func spawn_invader_projectile(position: Vector2) -> void:
	projectile_manager.spawn_invader_projectile(position + self.position, projectile)

