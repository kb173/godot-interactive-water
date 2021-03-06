shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform sampler2D previous_frame;

uniform float water_height = 0.6;

uniform float height_damping = 0.13;
uniform float velocity_damping = 0.8;
uniform float spread = 0.94;

// Height and Velocity are encoded in two components each, so RG is height and BA is velocity.
// This is needed to get a workable accuracy.
float read_height(sampler2D tex, vec2 uv) {
	return texture(tex, uv).r + texture(tex, uv).g / 255.0;
}
float read_velocity(sampler2D tex, vec2 uv) {
	return texture(tex, uv).b + texture(tex, uv).a / 255.0;
}
float get_encoded_remainder(float num) {
	return fract(num * 255.0);
}

void fragment() {
	// Read values here
	float height_here = read_height(previous_frame, UV);
	float velocity_here = read_velocity(previous_frame, UV);
	
	// Apply force towards the base height
	// This follows from the damped harmonic oscillator equation F = -kx-bv
	float force = -height_damping * (height_here - water_height) - velocity_here * velocity_damping;
	float acceleration_here = force;
	
	// In addition to each individual height behaving like a spring, neighbouring heights are
	// "connected by springs" as well:
	
	// Read more samples
	float uv_mod = 1.0 / float(textureSize(previous_frame, 0).x);
	
	float height_up = read_height(previous_frame, UV + vec2(0.0, uv_mod));
	float height_down = read_height(previous_frame, UV + vec2(0.0, -uv_mod));
	float height_left = read_height(previous_frame, UV + vec2(-uv_mod, 0.0));
	float height_right = read_height(previous_frame, UV + vec2(uv_mod, 0.0));
	
	// Calculate differences
	float up_delta = spread * (height_up - height_here);
	float down_delta = spread * (height_down - height_here);
	float left_delta = spread * (height_left - height_here);
	float right_delta = spread * (height_right - height_here);
	
	// Use the biggest delta to apply to this height
	float sum_delta = max(max(left_delta, right_delta), max(up_delta, down_delta));
	
	// Apply velocity and height
	velocity_here += sum_delta + acceleration_here;
	height_here += velocity_here;
	
	// Write to the texture
	COLOR = vec4(
		height_here, get_encoded_remainder(height_here),
		velocity_here, get_encoded_remainder(velocity_here)
	);
}