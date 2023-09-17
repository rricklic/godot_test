shader_type canvas_item;

// texture() - function to manipulate texture: which texture, where to manipulate (UV coordinate e.g.: 0-1)
// TEXTURE - (constant) texture of this shader
// UV - (constant) UV coordinate of this sampling
// COLOR - the color of this pixel
// uniform - shader input constant value; can be set in IDE from "Shader Parameters"
// hint_range() - define the valid values for a uniform

uniform float slant : hint_range(0.1, 10) = 2.0;

void fragment()
{
	vec2 uv = UV;
	uv.x += uv.y * slant;
	vec4 pixel_color = texture(TEXTURE, uv); // Sample this pixel
	COLOR = pixel_color; // Set this pixel
}
