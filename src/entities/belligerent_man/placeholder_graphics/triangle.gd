extends Sprite2D

func _ready() -> void:
	var size = Vector2i(64, 64)
	var img = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0)) # Transparent

	var triangle: Array[Vector2i] = [
		Vector2i(32, 0),
		Vector2i(0, 64),
		Vector2i(64, 64),
	]

	## Iterate over every point in the generated image and
	##  fill it in white if the given point is within the constraints
	##  of the triangle defined by `triangle`.
	for y in range(size.y):
		for x in range(size.x):
			var v = Vector2i(x, y)
			if _point_in_triangle(v, triangle):
				img.set_pixel(x, y, Color(1, 1, 1, 1))

	texture = ImageTexture.create_from_image(img)

## Use the area method to determine whether or not a given point
##  is inside the triangle
func _point_in_triangle(p: Vector2i, tri: Array[Vector2i]) -> bool:
	var a = tri[0]
	var b = tri[1]
	var c = tri[2]

	# Calculate the area of the target triangle
	var tri_area: float = abs(a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) / 2

	# Calculate the areas of all three smaller triangles created by 
	#  replacing each point of the target triangle with point `p`
	var pa_tri_area: float = abs(p.x * (b.y - c.y) + b.x * (c.y - p.y) + c.x * (p.y - b.y)) / 2
	var pb_tri_area: float = abs(a.x * (p.y - c.y) + p.x * (c.y - a.y) + c.x * (a.y - p.y)) / 2
	var pc_tri_area: float = abs(a.x * (b.y - p.y) + b.x * (p.y - a.y) + p.x * (a.y - b.y)) / 2

	var p_areas = pa_tri_area + pb_tri_area + pc_tri_area

	return is_equal_approx(tri_area, p_areas)
