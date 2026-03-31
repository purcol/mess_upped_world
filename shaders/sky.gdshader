shader_type canvas_item;

uniform sampler2D sct : hint_screen_texture;

uniform float uv_scale;
varying vec2 world_uv;

void vertex() {
	// Called for every vertex the material is visible on.
	//world_uv = (MODEL_MATRIX*vec4(VERTEX.xy,0.0,1.0)).xy / 128.0;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR = texture(TEXTURE, world_uv * uv_scale);
	vec2 final_uv = SCREEN_UV;
	COLOR = texture(sct, final_uv);
	COLOR = vec4(COLOR.r*(sin(TIME)*UV.x),COLOR.g,COLOR.b,1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
