extends Spatial


var using_second_viewport := false


func _ready():
	# Set an initial "previous frame"
	var first_image = Image.new()
	
	first_image.create(1, 1, false, Image.FORMAT_R8)
	first_image.lock()
	first_image.set_pixel(0, 0, Color(1.0, 1.0, 1.0))
	first_image.unlock()
	
	var first_texture = ImageTexture.new()
	first_texture.create_from_image(first_image)
	
	$WaterHeights.set_previous_texture(first_texture)


func _process(delta):
	# Get result of previous frame
	var result = $WaterHeights.get_texture(using_second_viewport)
	
	# Set it as the data of the water mesh
	$WaterMesh.material_override.set_shader_param("water_heights", result)
	
	# Calculate a new frame
	var previous_frame = ImageTexture.new()
	previous_frame.create_from_image(result.get_data())
	
	$WaterHeights.set_previous_texture(previous_frame)
