extends Spatial


const ray_length = 10


func _physics_process(delta):
	if Input.is_mouse_button_pressed(1):
		# If the left mouse button was pressed, cast a ray towards the mouse position
		var mouse_pos = get_viewport().get_mouse_position()
		
		var camera = $Camera
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * ray_length
		
		var result = get_world().direct_space_state.intersect_ray(from, to)
		
		if not result.empty():
			# If there was a collision, set the depth of the water at that position
			var position_2d = Vector2(result.position.x, result.position.z)
			
			position_2d += Vector2(1.0, 1.0)
			position_2d /= 2.0
			
			$Water.set_depth_at_position(position_2d, 0.0)
