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

	match direction:
		Direction.UP:
			self.velocity = self.velocity * -1
		Direction.DOWN:
			pass

func set_size(thickness_px: float, length_px: float) -> void:
	var sprite: Sprite2D = $Sprite
	sprite.scale = Vector2(thickness_px, length_px)

func tick() -> void:
	self.position += self.velocity
