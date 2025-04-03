shader_type canvas_item;

uniform bool flash;

void fragment() {
	if (flash) {
		COLOR.xyz = vec3(1.0);
	}
}

