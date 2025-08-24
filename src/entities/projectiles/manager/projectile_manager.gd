extends Node2D

var projectiles: Array = []

func _ready() -> void:
	# Subscribe to the global clock for ticks
	Clock.subscribe(self)

func tick() -> void:
	for projectile in projectiles:
		projectile.tick()

func spawn_enemy_projectile(
	spawn_position: Vector2, 
	projectile_scene: PackedScene
) -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.position = spawn_position
	projectile.direction = projectile.Direction.UP
	add_child(projectile)
	projectiles.push_back(projectile)

func spawn_invader_projectile(
	spawn_position: Vector2,
	projectile_scene: PackedScene
) -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.position = spawn_position
	projectile.direction = projectile.Direction.DOWN
	add_child(projectile)
	projectiles.push_back(projectile)
