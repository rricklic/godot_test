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
// TIME - (constant) current time

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise;
uniform vec2 scroll1 = vec2(0.1, 0.1);
uniform vec2 scroll2 = vec2(0.2, 0.2);

void fragment()
{
	float color1 = texture(TEXTURE, UV + scroll1 * TIME).r;
	float color2 = texture(noise, UV + scroll2 * TIME).r;
	float energy = color1 * color2;
	COLOR = vec4(energy, energy, energy, 1);
}
