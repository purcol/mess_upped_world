shader_type canvas_item;



void fragment() {
	vec2 fixed_uv = UV;
	COLOR.a = fixed_uv.y;
}