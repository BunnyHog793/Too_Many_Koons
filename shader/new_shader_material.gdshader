shader_type canvas_item;

uniform float time_factor = 1;
uniform vec2 amplitude = vec2(10.0, 10.0);
uniform vec4 in_color;
uniform float mix_amt = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.x += cos(TIME * time_factor + VERTEX.x + VERTEX.y) * amplitude.x;
	VERTEX.y += sin(TIME * time_factor + VERTEX.y + VERTEX.x) * amplitude.y;
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (COLOR.a > 0.0) {
		COLOR = mix(COLOR, in_color, mix_amt * (sin(TIME*time_factor) + .5));
		//COLOR = vec4(1.0-COLOR.r, 1.0-COLOR.g, 1.0-COLOR.b, 1.0);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
