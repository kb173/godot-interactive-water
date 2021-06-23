shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform sampler2D previous_frame;

uniform float water_height = 0.5;

uniform float height_damping = 0.05;
uniform float velocity_damping = 0.05;
uniform float spread = 0.1;

float read_height(sampler2D tex, vec2 uv) {
	return texture(tex, uv).r + texture(tex, uv).g / 255.0;
}

float get_encoded_remainder(float num) {
	return fract(num * 255.0);
}

void fragment() {
	// Read
	float height_here = read_height(previous_frame, UV);
	float velocity_here = texture(previous_frame, UV).b;
	float acceleration_here = texture(previous_frame, UV).a;
	
	// Apply force towards the base height
	float force = (height_here - water_height) * height_damping + velocity_here * velocity_damping;
	acceleration_here = -force;
	
	velocity_here += acceleration_here;
	height_here += velocity_here; // TODO: Take delta time into account
	
	// Update values based on neighbouring values
	
	// Read more samples
	float uv_mod = 1.0 / 64.0;
	
	float height_up = read_height(previous_frame, UV + vec2(0.0, uv_mod));
	float height_down = read_height(previous_frame, UV + vec2(0.0, -uv_mod));
	float height_left = read_height(previous_frame, UV + vec2(-uv_mod, 0.0));
	float height_right = read_height(previous_frame, UV + vec2(uv_mod, 0.0));
	
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
	COLOR = vec4(height_here, get_encoded_remainder(height_here), velocity_here, acceleration_here);
}