shader_type canvas_item;

// texture() - function to manipulate texture: which texture, where to manipulate (UV coordinate e.g.: 0-1)
// TEXTURE - (constant) texture of this shader
// UV - (constant) UV coordinate of this sampling
// COLOR - the color of this pixel
// uniform - shader input constant value; can be set in IDE from "Shader Parameters"
// hint_range() - define the valid values for a uniform

void fragment()
{
	vec4 pixel_color = texture(TEXTURE, UV); // Sample this pixel
	float brightness = (pixel_color.r + pixel_color.g + pixel_color.b) / 3.0;
	vec4 grayscale = vec4(brightness, brightness, brightness, pixel_color.a);
	COLOR = grayscale; // Set this pixel
}
