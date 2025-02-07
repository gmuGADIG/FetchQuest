shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NOISE_TEXTURE;
uniform float speed : hint_range(0.05, 0.5) = 0.1;
uniform float strength : hint_range(0.05, 0.5) = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float noise_values = texture(NOISE_TEXTURE, UV + vec2(sin(TIME), cos(TIME)) * speed).r;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - (strength / 2.0) + vec2(noise_values) * strength);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
