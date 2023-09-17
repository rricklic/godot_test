shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float pixel_factor : hint_range(0.0, 1.0) = 0.5;

void fragment()
{
	vec2 pixel_number = vec2(textureSize(SCREEN_TEXTURE, 0)) * pixel_factor;
	vec2 pixelated_uv = pixel_factor == 1.0 ? SCREEN_UV : round(SCREEN_UV * pixel_number) / pixel_number;
	COLOR = texture(SCREEN_TEXTURE, pixelated_uv);
}
