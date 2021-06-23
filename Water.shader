shader_type spatial;

uniform sampler2D water_heights;


float read_height(sampler2D tex, vec2 uv) {
	return texture(tex, uv).r + texture(tex, uv).g / 255.0;
}

void fragment() {
	ALBEDO = vec3(0.2, 0.5, 0.8) * read_height(water_heights, UV);
}

void vertex() {
	VERTEX.y = read_height(water_heights, UV);
}