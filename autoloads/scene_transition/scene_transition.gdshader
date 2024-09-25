shader_type canvas_item;

// Provide a basic shader-based animation for now.
uniform float t;
uniform float dir = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(dir * (UV.x + UV.y) > dir * t) {
		discard;
	}
}
