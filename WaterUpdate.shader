shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform sampler2D previous_frame: hint_black_albedo;

uniform float water_height = 0.5;

uniform float height_damping = 0.05;
uniform float velocity_damping = 0.05;
uniform float spread = 0.1;

void fragment() {
	// Read
	float height_here = texture(previous_frame, UV).r;
	float velocity_here = texture(previous_frame, UV).g;
	float acceleration_here = texture(previous_frame, UV).b;
	
	// Apply force towards the base height
	float force = (height_here - water_height) * height_damping + velocity_here * velocity_damping;
	acceleration_here = -force;
	
	velocity_here += acceleration_here;
	height_here += velocity_here; // TODO: Take delta time into account
	
	// Update values based on neighbouring values
	
	// Read more samples
	float uv_mod = 1.0 / 128.0;
	float height_up = texture(previous_frame, UV + vec2(0.0, uv_mod)).r;
	float height_down = texture(previous_frame, UV + vec2(0.0, -uv_mod)).r;
	float height_left = texture(previous_frame, UV + vec2(- uv_mod, 0.0)).r;
	float height_right = texture(previous_frame, UV + vec2(uv_mod, 0.0)).r;
	
	// Calculate differences
	float up_delta = spread * (height_up - height_here);
	float down_delta = spread * (height_down - height_here);
	float left_delta = spread * (height_left - height_here);
	float right_delta = spread * (height_right - height_here);
	
	float sum_delta = left_delta + right_delta + up_delta + down_delta;
	
	velocity_here += sum_delta;
	height_here += sum_delta;
	
	//height_here = (height_up + height_down + height_left + height_right) / 4.0;
	
	// Modification
	//height_here = mix(height_here, water_height, 0.1);
	
	// Write
	COLOR = vec4(height_here, velocity_here, acceleration_here, 1.0);
}