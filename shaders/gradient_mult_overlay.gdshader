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

uniform sampler2D gradient;
uniform float mix_amount : hint_range(0.0, 1.0) = 0.5;

void fragment()
{
	vec4 pixel_color = texture(TEXTURE, UV);
	vec4 gradient_color = texture(gradient, UV);
	COLOR = mix(pixel_color, gradient_color, mix_amount);
}
