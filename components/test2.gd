extends Node2D

func _ready() -> void:
	pass

func _enter_tree() -> void:
	get_tree().create_timer(3.0).timeout.connect(_transition)	

func _transition() -> void:
	var transition_outs: Array[SceneTransitionShader]
	transition_outs.push_back(SceneTransitionShader.new(SceneTransitionShader.Transition.PIXELATE))
	transition_outs.push_back(SceneTransitionShader.new(SceneTransitionShader.Transition.COLOR_FADE))
	
	var transition_ins: Array[SceneTransitionShader]
	transition_ins.push_back(SceneTransitionShader.new(SceneTransitionShader.Transition.PIXELATE_2))
	transition_ins.push_back(SceneTransitionShader.new(SceneTransitionShader.Transition.COLOR_FADE_2))

	SceneMgr.signal_transition.emit("res://components/test.tscn", transition_outs, transition_ins, false)

func _physics_process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_6)):
		SceneMgr.signal_transition.emit("res://components/test.tscn")
