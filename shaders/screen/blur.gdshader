shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float intensity: hint_range(0.0, 5.0) = 1.0;

void fragment()
{
	COLOR.rgb = textureLod(screen_texture, SCREEN_UV, intensity).rgb;
}