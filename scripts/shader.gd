class_name ShaderTransition

var shader_path: String
var start_params: Dictionary
var end_params: Dictionary
var durations: Dictionary

static func init(shader_path: String) -> ShaderTransition:
	var shader_transition: ShaderTransition = ShaderTransition.new()
	shader_transition.shader_path = shader_path
	return shader_transition

func add_param(
		param_name: String,
		start_value: Variant,
		end_value: Variant,
		duration: float) -> ShaderTransition: 
	start_params[param_name] = start_value
	end_params[param_name] = end_value
	durations[param_name] = duration
	return self
