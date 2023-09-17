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
uniform float distort_amount : hint_range(0.0, 1.0) = 0.1;

void fragment()
{
	vec2 screen_uv = SCREEN_UV + texture(TEXTURE, UV).a * distort_amount;
	vec4 pixel_color = texture(SCREEN_TEXTURE, screen_uv);
	COLOR = pixel_color;
}
