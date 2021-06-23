shader_type canvas_item;
render_mode unshaded, blend_disabled;

uniform sampler2D previous_frame: hint_black_albedo;

uniform float water_height = 0.5;

void fragment() {
	// Read
	float height_here = texture(previous_frame, UV).r;
	
	// Read more samples
	float uv_mod = 1.0 / 128.0;
	float height_up = texture(previous_frame, UV + vec2(0.0, uv_mod)).r;
	float height_down = texture(previous_frame, UV + vec2(0.0, -uv_mod)).r;
	float height_left = texture(previous_frame, UV + vec2(- uv_mod, 0.0)).r;
	float height_right = texture(previous_frame, UV + vec2(uv_mod, 0.0)).r;
	
	height_here = (height_up + height_down + height_left + height_right) / 4.0;
	
	// Modification
	height_here = mix(height_here, water_height, 0.1);
	
	// Write
	COLOR = vec4(height_here, 0.0, 0.0, 1.0);
}