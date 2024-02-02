class_name SceneTransitionShader extends SceneTransition

################################################################################
# Description: 
################################################################################



# Signals
#signal signal_name(foo)

enum Transition {
	BLUR,
	COLOR_FADE,
	COLOR_FADE_2,
	PIXELATE,
	PIXELATE_2
}

#class ShaderDetails:
#	var shader_path: String
#	var default_params: Dictionary

const _SHADER_RESOURCE_DICT: Dictionary = {
	Transition.BLUR: "res://shaders/screen/blur.gdshader",
	Transition.COLOR_FADE: "res://shaders/transition/color_fade.gdshader",
	Transition.COLOR_FADE_2: "res://shaders/transition/color_fade.gdshader",
	Transition.PIXELATE: "res://shaders/transition/pixelate.gdshader",
	Transition.PIXELATE_2: "res://shaders/transition/pixelate.gdshader"
}

# Export variables
#@export var speed: float = 200.0

# Variables
#var count: int = 0
#   set(value):
#       count = value
#   get: 
#       return count

var _shader_transition: SceneTransitionShader.Transition
var shader: TextureRect

func _init(shader_transition: SceneTransitionShader.Transition) -> void:
	super(_SHADER_RESOURCE_DICT.get(shader_transition))
	_shader_transition = shader_transition
	
	if (shader_transition == SceneTransitionShader.Transition.COLOR_FADE):
		start_params["amount"] = 0.0
		end_params["amount"] = 1.0
		durations["amount"] = 2.0
		start_params["target_color"] = [0.0, 0.0, 0.0, 1.0]
		end_params["target_color"] = [0.0, 0.0, 0.0, 1.0]
		durations["target_color"] = 2.0
	elif (shader_transition == SceneTransitionShader.Transition.COLOR_FADE_2):
		start_params["amount"] = 1.0
		end_params["amount"] = 0.0
		durations["amount"] = 2.0
		start_params["target_color"] = [0.0, 0.0, 0.0, 1.0]
		end_params["target_color"] = [0.0, 0.0, 0.0, 1.0]
		durations["target_color"] = 2.0
	
	if (shader_transition == SceneTransitionShader.Transition.PIXELATE):
		start_params["pixel_factor"] = 1.0
		end_params["pixel_factor"] = 0.0
		durations["pixel_factor"] = 1.0
	elif (shader_transition == SceneTransitionShader.Transition.PIXELATE_2):
		start_params["pixel_factor"] = 0.0
		end_params["pixel_factor"] = 1.0
		durations["pixel_factor"] = 1.0
	
	ease = Tween.EASE_IN
	trans = Tween.TRANS_LINEAR

	var shader_material: ShaderMaterial = _create_shader_material(_resource_path)
	shader = _create_shader_texture_rect(shader_material)
	
func _create_shader_material(shader_path: String) -> ShaderMaterial:
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = load(shader_path) # TODO: support threaded loading
	shader_material.resource_local_to_scene = true
	return shader_material

func _create_shader_texture_rect(shader_material: ShaderMaterial) -> TextureRect:
	var texture_rect = TextureRect.new()
	texture_rect.size = GlobalFunctions.get_viewport_size()
	texture_rect.texture = PlaceholderTexture2D.new()
	texture_rect.material = shader_material
	return texture_rect
	
func start(node: Node, tween: Tween) -> void:
	for key in start_params.keys():
		shader.material.set_shader_parameter(key, start_params.get(key))
	
	#var back_buffer_copy: BackBufferCopy = BackBufferCopy.new()
	#back_buffer_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
	#get_tree().root.add_child(back_buffer_copy)	
	#temps.push_back(back_buffer_copy)
		
	var canvas_layer: CanvasLayer = CanvasLayer.new()
	canvas_layer.add_to_group(SceneMgr.GROUP)
	canvas_layer.add_child(shader)
	
	for key in end_params:
		tween.tween_property(
			shader.material,
			"shader_parameter/" + key,
			end_params.get(key),
			durations.get(key)).from_current().set_trans(trans).set_ease(ease)
			
	node.add_child(canvas_layer)	
