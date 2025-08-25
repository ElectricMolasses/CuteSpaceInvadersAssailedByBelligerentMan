extends Node2D

var projectiles: Array = []

func _ready() -> void:
	# Subscribe to the global clock for ticks
	Clock.subscribe(self)

func tick() -> void:
	var idxs_to_remove: Array[int] = []
	for i in len(projectiles):
		if projectiles[i]:
			projectiles[i].tick()
		else:
			idxs_to_remove.push_front(i)
	
	for idx in idxs_to_remove:
		projectiles.remove_at(idx)

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
	projectile.rotation = deg_to_rad(180)
	add_child(projectile)
	projectiles.push_back(projectile)
