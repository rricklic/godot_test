extends Node2D

class_name SceneManager

static var instance: SceneManager = SceneManager.new()

signal signal_transition(current: Node2D, next: String, shader_outs: Array[ShaderTransition], shader_ins: Array[ShaderTransition])

#var current: Node2D
#var next: String
#var shader_outs_paths: Array[String]
#var shader_outs_params: Array[Dictionary]
#var shader_ins_paths: Array[String]
#var shader_ins_params: Array[Dictionary]
var temps: Array[Node];

@onready var current_scene_container: Control = $CurrentSceneContainer
func _ready():
	instance.signal_transition.connect(_on_transition)

func _create_shader(shader_transition: ShaderTransition) -> TextureRect:
	var shaderMaterial: ShaderMaterial = ShaderMaterial.new()
	shaderMaterial.shader = load(shader_transition.shader_path)
	shaderMaterial.resource_local_to_scene = true
	for key in shader_transition.start_params.keys():
		shaderMaterial.set_shader_parameter(key, shader_transition.start_params.get(key))
	var texture_rect = TextureRect.new()
	texture_rect.size = Vector2(2000, 2000) # TODO: better wasy to do th
	texture_rect.texture = PlaceholderTexture2D.new()
	texture_rect.material = shaderMaterial
	return texture_rect;

func _on_transition(
		current: Node2D,
		next: String,
		shader_outs: Array[ShaderTransition],
		shader_ins: Array[ShaderTransition]) -> void:

	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	
	for shader_transition in shader_outs:
		var back_buffer_copy: BackBufferCopy = BackBufferCopy.new()
		back_buffer_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
		current_scene_container.add_child(back_buffer_copy)
		var texture_rect: TextureRect = _create_shader(shader_transition)
		current_scene_container.add_child(texture_rect)
		temps.push_back(back_buffer_copy)
		temps.push_back(texture_rect)
		for key in shader_transition.end_params:
			tween.tween_property(texture_rect.material, "shader_parameter/" + key, shader_transition.end_params.get(key), shader_transition.durations.get(key)).from_current()

	tween.set_parallel(false)
	tween.tween_callback(_on_transition_in.bind(current, next, shader_ins))

func _on_transition_in(current: Node2D, next: String, shader_ins: Array[ShaderTransition]) -> void:
	_cleanup_temps()

	current.queue_free()
	current_scene_container.add_child(load(next).instantiate())
	
	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)

	for shader_transition in shader_ins:
		var back_buffer_copy: BackBufferCopy = BackBufferCopy.new()
		back_buffer_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
		current_scene_container.add_child(back_buffer_copy)
		var texture_rect: TextureRect = _create_shader(shader_transition)
		current_scene_container.add_child(texture_rect)
		temps.push_back(back_buffer_copy)
		temps.push_back(texture_rect)
		for key in shader_transition.end_params:
			tween.tween_property(texture_rect.material, "shader_parameter/" + key, shader_transition.end_params.get(key), shader_transition.durations.get(key)).from_current()
		
	tween.set_parallel(false)
	tween.tween_callback(_cleanup_temps)

func _cleanup_temps() -> void:
	for temp in temps:
		temp.queue_free()
	temps.clear()
