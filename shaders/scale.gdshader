shader_type canvas_item;

// texture() - function to manipulate texture: which texture, where to manipulate (UV coordinate e.g.: 0-1)
// TEXTURE - the texture of this shader
// UV - UV coordinate of this sampling
// COLOR - the color of this pixel
// uniform - shader input constant value; can be set in IDE from "Shader Parameters"
// hint_range() - define the valid values for a uniform

uniform float scale : hint_range(0.1, 10) = 0.5;

void fragment()
{
	vec4 pixel_color = texture(TEXTURE, UV * scale); // Sample this pixel
	COLOR = pixel_color; // Set this pixel
}
