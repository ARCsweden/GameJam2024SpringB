shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noice : repeat_enable;
uniform vec2 scroll_speed = vec2(0.05,0.05);
uniform float strength : hint_range(-1,1) = 0.2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 noice_col = texture(noice,UV + scroll_speed * TIME);
	vec4 screen_col = texture(SCREEN_TEXTURE,SCREEN_UV + strength * noice_col.rr);
	COLOR = screen_col;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
