class_name SceneTransition extends Object

var _resource_path: String
var start_params: Dictionary
var end_params: Dictionary
var durations: Dictionary
var ease: Tween.EaseType
var trans: Tween.TransitionType

enum Parameter {
	AMOUNT,
	TARGET_COLOR,
	PIXEL_FACTOR,
}

enum Type {
	ANIMATION,
	TWEEN,
	SHADER
}

enum AnimationTransition {
}

enum TweenTransition {
}



func _init(resource_path: String) -> void:
	_resource_path = resource_path

#func add_param(
#		param_name: String,
#		start_value: Variant,
#		end_value: Variant,
#		duration: float,
#		ease: Tween.EaseType = Tween.EaseType.EASE_OUT,
#		trans: Tween.TransitionType = Tween.TransitionType.TRANS_CIRC): 
#	start_params[param_name] = start_value
#	end_params[param_name] = end_value
#	durations[param_name] = duration
#	ease = ease
#	trans = trans

