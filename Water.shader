shader_type spatial;

uniform sampler2D water_heights;


void fragment() {
	ALBEDO = vec3(0.2, 0.5, 0.8) * texture(water_heights, UV).r;
}

void vertex() {
	VERTEX.y = texture(water_heights, UV).r;
}