class_name ShaderTransition

var shader_path: String
var start_params: Dictionary
var end_params: Dictionary
var durations: Dictionary
var ease: Tween.EaseType
var trans: Tween.TransitionType

enum ScreenShader {
	Blur,
	ColorFade,
	Pixelate
}

static func init(shader_path: String) -> ShaderTransition:
	var shader_transition: ShaderTransition = ShaderTransition.new()
	shader_transition.shader_path = shader_path
	return shader_transition

func add_param(
		param_name: String,
		start_value: Variant,
		end_value: Variant,
		duration: float,
		ease: Tween.EaseType = Tween.EaseType.EASE_OUT,
		trans: Tween.TransitionType = Tween.TransitionType.TRANS_CIRC) -> ShaderTransition: 
	self.start_params[param_name] = start_value
	self.end_params[param_name] = end_value
	self.durations[param_name] = duration
	self.ease = ease
	self.trans = trans
	return self
