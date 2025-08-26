extends Sprite2D

func _ready():
	generate_voronoi_diagram(Vector2i(128, 128), 2)

func _on_button_pressed() -> void:
	generate_voronoi_diagram(Vector2i(128, 128), 2)
	
func generate_voronoi_diagram(img_size: Vector2i, num_cells: int):
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	var img = Image.create(img_size.x, img_size.y, false, Image.FORMAT_RGB8)

	var points = []
	var colors = []
	
	for i in range(num_cells):
		
		randomize()
		var color_possibilities = [Color.GREEN, Color.YELLOW, Color.PURPLE, Color.CRIMSON, Color.FUCHSIA]
		colors.append(color_possibilities[randi() % color_possibilities.size()])
	
	for y in range(img.get_height()/4):
		for x in range(img.get_width()/4):
			print("x: " + str(x) + ", y: " + str(y))
			img.set_pixel(x, y, colors[0])
	
	#for i in range(num_cells):
		#print(i)
		#for y in range(0, 300):
			#for x in range(0, 300):
				#print("x: " + str(x) + ", y: " + str(y))
				#img.set_pixel(x, y, colors[i])
		
	#for i in range(num_cells):
		#points.append(Vector2i(int(randf() * img.get_width()), int(randf() * img.get_height())))
#
		#randomize()
		#var color_possibilities = [Color.GREEN, Color.YELLOW, Color.PURPLE, Color.CRIMSON, Color.FUCHSIA]
		#colors.append(color_possibilities[randi() % color_possibilities.size()])
#
	#for y in range(img.get_height()):
		#for x in range(img.get_width()):
			#var dmin = float(img.get_size().length())
			#var j = -1
			#for i in range(num_cells):
				#var d = (points[i] - Vector2i(x, y)).length()
				#if d < dmin:
					#dmin = d
					#j = i
					#
			#var x_add = 0
			#var y_add = 0
			#
			##if x < 300:
				##x_add = 100
			#
			##if y < 400:
				##y_add = 100
				#
			#img.set_pixel(x, y, colors[j])

	var generated_texture = ImageTexture.create_from_image(img)

	self.texture = generated_texture
