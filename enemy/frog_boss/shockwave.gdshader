shader_type canvas_item;

const float inner_r = 0.4;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 dist_vector = vec2(0.5, 0.5) - UV;
	float angle = atan(dist_vector.x, dist_vector.y);
	float dist = length(dist_vector);
	if (dist > 0.5) {
		COLOR = vec4(1, 1, 1, 0);
	} else {
		float alpha = max((dist - inner_r) * (0.5/(0.5-inner_r)), 0);
		COLOR = vec4(1, 1, 1, alpha);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
