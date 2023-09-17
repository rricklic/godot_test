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

// NOTE: Must be used on a Sprite2D/TextureRect with noise texture.
//       Set texture to seamless (TextureRect->Texture->Seamless) and
//       repeat on (CanvasItem->Texture->Repeat)

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float distort_amount : hint_range(-1.0, 1.0) = 0.01;
uniform vec2 scroll = vec2(0.1, 0.1);
uniform bool is_time_enabled = false;
uniform float time_multiplier : hint_range(1.0, 10.0, 0.1) = 1.0;

void fragment()
{
	float time = is_time_enabled ? TIME * time_multiplier : 0.0;
	vec2 screen_uv = SCREEN_UV + texture(TEXTURE, UV + scroll * time).r * distort_amount;
	//vec2 screen_uv = SCREEN_UV + texture(TEXTURE, UV + scroll * sin(time)).r * distort_amount; // Zoom in/out in noise
	//vec2 screen_uv = SCREEN_UV + texture(TEXTURE, UV + scroll + sin(time)).r * distort_amount; // Pan left/right in noise
	vec4 pixel_color = texture(SCREEN_TEXTURE, screen_uv);
	COLOR = pixel_color;
}
