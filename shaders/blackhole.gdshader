shader_type canvas_item;

// texture() - function to manipulate texture: which texture, where to manipulate (UV coordinate e.g.: 0-1)
// TEXTURE - (constant) texture of this shader
// SCREEN_TEXTURE - (constant) texture of the screen
// UV - (constant) UV coordinate of this sampling
// SCREEN_UV - (constant) point below screen
// COLOR - the color of this pixel
// uniform - shader input constant value; can be set in IDE from "Shader Parameters"
// hint_range() - define the valid values for a uniform
// source_color - hint that IDE should only allow color
// mix(source, dest, interpolation) - function to interpolate between source and destination color

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D curve;
uniform float amount : hint_range(0.0, 1.0) = 0.6;

void fragment()
{
	vec2 vec_to_center = vec2(0.5, 0.5) - UV;
	float dist_to_center = length(vec_to_center);
	float curve_value = texture(curve, vec2(dist_to_center)).r;
	vec2 diff = normalize(vec_to_center) * amount * curve_value;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - diff);
}
