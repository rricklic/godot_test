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

void fragment()
{
	vec4 pixel_color = texture(TEXTURE, UV);
	float brightness = (pixel_color.r + pixel_color.g + pixel_color.b) / 3.0;
	vec4 gradient_color = texture(gradient, vec2(brightness));
	COLOR = gradient_color;
}
