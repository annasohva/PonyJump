shader_type canvas_item;
render_mode blend_mix;

uniform vec4 tex_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float blend_amount : hint_range(0.0, 1.0) = 1;

void vertex() {
	COLOR = mix(COLOR, tex_color, blend_amount);
}
