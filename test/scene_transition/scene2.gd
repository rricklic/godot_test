extends Node2D

class_name Scene2

@onready var next_scene: String = "res://test/scene_transition/scene1.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_key_input(event: InputEvent):
	if (Input.is_key_pressed(KEY_N)):
		var shader_outs: Array[ShaderTransition]
#		shader_outs.push_back(ShaderTransition.init("res://shaders/transition/color_fade.gdshader")
#			.add_param("amount", 0.0, 1.0, 1.0)
#			.add_param("target_color", [0.0, 0.0, 0.0, 1.0], [0.0, 0.0, 0.0, 1.0], 1.0))
		shader_outs.push_back(ShaderTransition.init("res://shaders/transition/pixelate.gdshader")
			.add_param("pixel_factor", 1.0, 0.0, 0.5))
		
		var shader_ins: Array[ShaderTransition]
#		shader_ins.push_back(ShaderTransition.init("res://shaders/transition/color_fade.gdshader")
#			.add_param("amount", 1.0, 0.0, 1.0)
#			.add_param("target_color", [0.0, 0.0, 0.0, 1.0], [0.0, 0.0, 0.0, 1.0], 2.0))
		shader_ins.push_back(ShaderTransition.init("res://shaders/transition/pixelate.gdshader")
			.add_param("pixel_factor", 0.0, 1.0, 0.5))
		
		SceneManager.instance.signal_transition.emit(self, next_scene, shader_outs, shader_ins)
