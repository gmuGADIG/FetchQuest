shader_type canvas_item;

const float MIN_COLOR = .20;
uniform bool enabled = false;

void fragment() {
	if (enabled) {
		float x = mod(UV.x + TIME / 2., 1.);
		x = max(x - .5, .5 - x);
		x *= 2.;
		vec3 color = vec3(max(x, MIN_COLOR), clamp(x, MIN_COLOR, .3), clamp(x, MIN_COLOR, .3));
		COLOR.xyz *= color;
	}
}

