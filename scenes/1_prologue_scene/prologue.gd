extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_player_click: AudioStreamPlayer = $AudioStreamPlayerClick
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var foreground: ColorRect = $Foreground

################################################################################
func _ready():
	#var tween = self.create_tween()
	#tween.set_trans(Tween.TRANS_CIRC)
	#tween.set_ease(Tween.EASE_OUT)
	#tween.tween_property(audio_player, "volume_db", -5, 2.5).from_current()
	#tween.set_ease(Tween.EASE_IN)
	#tween.tween_property(audio_player, "volume_db", -80, 6.0)
	#tween.tween_callback(audio_player.stop)
	
	var tween2 = self.create_tween()
	tween2.set_trans(Tween.TRANS_LINEAR)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property(audio_player_click, "volume_db", .75, 5).from(-80)
	
	var timer: SceneTreeTimer = get_tree().create_timer(1.5, true, false, false)
	timer.timeout.connect(_fade_in)
	animation_player.play("bob")

################################################################################
func _fade_in() -> void:
	foreground.visible = false
	
	var shader_outs: Array[ShaderTransition]
	shader_outs.push_back(ShaderTransition.init("res://shaders/transition/color_fade.gdshader")
		.add_param("amount", 1.0, 0.0, 10.0, Tween.EASE_IN_OUT, Tween.TRANS_CUBIC)
		.add_param("target_color", [1.0, 1.0, 1.0, 1.0], [1.0, 1.0, 1.0, 1.0], 10.0, Tween.EASE_IN_OUT, Tween.TRANS_CUBIC))
	shader_outs.push_back(ShaderTransition.init("res://shaders/screen/blur.gdshader")
		.add_param("intensity", 5.0, 0.0, 10.0, Tween.EASE_IN_OUT, Tween.TRANS_CUBIC))
	var shader_ins: Array[ShaderTransition]
	
	SceneManager.instance.signal_transition.emit(self, "", shader_outs, shader_ins)
	
	var timer: SceneTreeTimer = get_tree().create_timer(10.0, true, false, false)
	timer.timeout.connect(_zoom_in)

################################################################################
func _zoom_in() -> void:
	#animation_player.get_animation("bob").loop_mode = Animation.LoopMode.LOOP_NONE
	animation_player.stop()
	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(camera, "zoom", Vector2(10, 10), 3.0).from_current()
	tween.tween_callback(_change_scene)
	
	var tween2 = self.create_tween()
	tween2.set_trans(Tween.TRANS_CIRC)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property(camera, "position", camera.position + Vector2(0.0, -30.0), 0.5).from_current()

################################################################################
func _change_scene() -> void:
	var tmp: Array[ShaderTransition]
	foreground.color = Color(0.0, 0.0, 0.0, 1.0)
	foreground.visible = true
	camera.zoom = Vector2(1, 1)
	camera.position = camera.position + Vector2(0, 30)
	SceneManager.instance.signal_transition.emit(self, "res://scenes/2_splash_screen/splash_screen.tscn", tmp, tmp)
