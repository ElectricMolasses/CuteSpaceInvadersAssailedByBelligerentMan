class_name Projectile
extends Area2D

enum Direction {
	UP,
	DOWN,
}

@export var velocity: Vector2 = Vector2(0, 30)
@export var direction: Direction = Direction.UP

func _ready() -> void:
	var sprite: Sprite2D = $Sprite
	if sprite.texture == null:
		var img: Image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
		img.fill(Color.WHITE)
		var texture = ImageTexture.create_from_image(img)
		sprite.texture = texture
	
	set_size(30, 30)

	connect("area_entered", _area_entered)

	match direction:
		Direction.UP:
			self.velocity = self.velocity * -1
		Direction.DOWN:
			pass

## Sets the width and length of a projectile. Finnicky, this shader's
##  a mess.
func set_size(thickness_px: float, length_px: float) -> void:
	var sprite: Sprite2D = $Sprite
	sprite.scale = Vector2(thickness_px, length_px)

func tick() -> void:
	self.position += self.velocity

## The projectiles are the authority on what happens in the event of
##  a collision. This is not ideal, but these are the compromises we 
##  make for game jams :D
func _area_entered(body: Node):
	if body is Projectile:
		queue_free()
	if body.get_parent() is Invader:
		# This grossness is basically built on knowing that projectiles
		#  will only be fired in single, opposing directions, based
		#  on the `team`. So if the projectile is going DOWN, we
		#  implicitly understand that we should not be calling
		#  kill on any `Invader`s it collides with.
		# This is straight up bad practice. Write a collision manager,
		#  or handle the logic of each entities collision with other 
		#  entities internally.
		if self.direction == Direction.DOWN:
			return
		body.get_parent().kill()
		queue_free()
	if body is BelligerentMan:
		if self.direction == Direction.UP:
			return
		body.kill()
		queue_free()
