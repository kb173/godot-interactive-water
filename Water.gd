extends Spatial


# Saves every frame as a PNG in the project directory. Use for debugging (with caution)
export var output_debug_textures := false
export var first_output_frame := 0
var _frame_number := 0


func _ready():
	# Set an initial "previous frame"
	var first_image = Image.new()
	
	first_image.create(1, 1, false, Image.FORMAT_RGBA8)
	first_image.lock()
	first_image.set_pixel(0, 0, Color(0.5, 0.0, 0.0, 0.0))
	first_image.unlock()
	
	var first_texture = ImageTexture.new()
	first_texture.create_from_image(first_image)
	
	$WaterHeights.set_previous_texture(first_texture)


func _physics_process(delta):
	if _frame_number == 0:
		_frame_number += 1
		return
	
	# Get result of previous frame
	var result = $WaterHeights.get_texture()
	
	# Set it as the data of the water mesh
	$WaterMesh.material_override.set_shader_param("water_heights", result)
	
	# Calculate a new frame. First, get the data of the last frame and modify it accordingly
	var image_data = result.get_data()
	
	# Set a random pixel every 100 frames for testing
	if _frame_number % 50 == 0:
		print("Setting pixel")
		image_data.lock()
		image_data.set_pixel(randi() % 64, randi() % 64, Color(0.0, 0.0, 0.0, 0.0))
		image_data.unlock()
	
	# Create an ImageTexture for this new frame
	var previous_frame = ImageTexture.new()
	previous_frame.create_from_image(image_data)
	
	# Set the previous texture in the shader so that a new texture will be available next frame
	$WaterHeights.set_previous_texture(previous_frame)
	
	# Debug output
	if output_debug_textures and _frame_number > first_output_frame:
		image_data.save_png("res://debugframes/frame%s.png" % [_frame_number])
	
	_frame_number += 1
