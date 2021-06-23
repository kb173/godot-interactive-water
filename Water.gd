extends Spatial

var first_frame := true

var frame_number := 0


func _ready():
	# Set an initial "previous frame"
	var first_image = Image.new()
	
	first_image.create(2, 2, false, Image.FORMAT_RGBA8)
	first_image.lock()
	first_image.set_pixel(0, 0, Color(0.0, 0.0, 0.0))
	first_image.set_pixel(0, 1, Color(0.0, 0.0, 0.0))
	first_image.set_pixel(1, 0, Color(0.0, 0.0, 0.0))
	first_image.set_pixel(1, 1, Color(1.0, 0.0, 0.0))
	first_image.unlock()
	
	var first_texture = ImageTexture.new()
	first_texture.create_from_image(first_image)
	
	$WaterHeights.set_previous_texture(first_texture)


func _process(delta):
	# Skip the first frame because that would swap around buffers that aren't properly rendered yet
	if first_frame:
		first_frame = false
		return
	
	# Get result of previous frame
	var result = $WaterHeights.get_texture()
	
	# Set it as the data of the water mesh
	$WaterMesh.material_override.set_shader_param("water_heights", result)
	
	# Calculate a new frame
	var previous_frame = ImageTexture.new()
	previous_frame.create_from_image(result.get_data())
	
	$WaterHeights.set_previous_texture(previous_frame)
	
	if false:
		previous_frame.get_data().save_png("res://frame%s.png" % [frame_number])
		frame_number += 1
