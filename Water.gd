extends Spatial


# Saves every frame as a PNG in the project directory. Use for debugging (with caution)
export var output_debug_textures := false
export var first_output_frame := 0
var _frame_number := 0

var _positions_to_set = []


func set_depth_at_position(pos: Vector2, depth: float):
	_positions_to_set.append([pos, depth])


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
	
	# Set pixels for testing
#	if true:
#			if _frame_number % 200 == 1:
#				print("Setting pixel")
#				var pos_x = randi() % 256
#				var pos_y = randi() % 256
#				image_data.lock()
#				image_data.set_pixel(50, 250, Color(0.0, 0.0, 0.0, 0.0))
#				image_data.set_pixel(51, 250, Color(0.0, 0.0, 0.0, 0.0))
#				image_data.set_pixel(100, 250, Color(0.0, 0.0, 0.0, 0.0))
#				image_data.set_pixel(101, 250, Color(0.0, 0.0, 0.0, 0.0))
#				image_data.set_pixel(150, 250, Color(0.0, 0.0, 0.0, 0.0))
#				image_data.set_pixel(151, 250, Color(0.0, 0.0, 0.0, 0.0))
#				image_data.set_pixel(200, 250, Color(0.0, 0.0, 0.0, 0.0))
#				image_data.set_pixel(201, 250, Color(0.0, 0.0, 0.0, 0.0))
#				image_data.unlock()
#	else:
#		if _frame_number % 50 == 0:
#			print("Setting pixel")
#			image_data.lock()
#			image_data.set_pixel(randi() % 256, randi() % 256, Color(0.0, 0.0, 0.0, 0.0))
#			image_data.unlock()
	
	# Set outstanding pixels
	for position_and_depth in _positions_to_set:
		var pos = position_and_depth[0]
		var depth = position_and_depth[1]
		
		image_data.lock()
		image_data.set_pixel(floor(pos.x * 255), floor(pos.y * 255), Color(depth, 0.0, 0.0, 0.0))
		image_data.unlock()
	
	_positions_to_set.clear()
	
	# Create an ImageTexture for this new frame
	var previous_frame = ImageTexture.new()
	previous_frame.create_from_image(image_data)
	
	# Set the previous texture in the shader so that a new texture will be available next frame
	$WaterHeights.set_previous_texture(previous_frame)
	
	# Debug output
	if output_debug_textures and _frame_number > first_output_frame:
		image_data.save_png("res://debugframes/frame%s.png" % [_frame_number])
	
	_frame_number += 1
