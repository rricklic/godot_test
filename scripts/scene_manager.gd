extends Node2D

class_name SceneManager

static var instance: SceneManager = SceneManager.new()

signal signal_transition(current: Node2D, next: String, shader_outs: Array[ShaderTransition], shader_ins: Array[ShaderTransition])

var temps: Array[Node];

@onready var scene_container: Control = $SceneContainer
func _ready():
	instance.signal_transition.connect(_on_transition)

func _create_shader(shader_transition: ShaderTransition) -> TextureRect:
	var shaderMaterial: ShaderMaterial = ShaderMaterial.new()
	shaderMaterial.shader = load(shader_transition.shader_path)
	shaderMaterial.resource_local_to_scene = true
	for key in shader_transition.start_params.keys():
		shaderMaterial.set_shader_parameter(key, shader_transition.start_params.get(key))
	var texture_rect = TextureRect.new()
	texture_rect.size = Vector2(2000, 2000) # TODO: better way to do th
	texture_rect.texture = PlaceholderTexture2D.new()
	texture_rect.material = shaderMaterial
	return texture_rect;

func _on_transition(
		current: Node2D,
		next: String,
		shader_outs: Array[ShaderTransition],
		shader_ins: Array[ShaderTransition]) -> void:

	var tween = self.create_tween()
	tween.set_parallel(true) # TODO: control parallel; chaining tweens
	
	for shader_transition in shader_outs:
		var back_buffer_copy: BackBufferCopy = BackBufferCopy.new()
		back_buffer_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
		scene_container.add_child(back_buffer_copy)
		var texture_rect: TextureRect = _create_shader(shader_transition)
		scene_container.add_child(texture_rect)
		temps.push_back(back_buffer_copy)
		temps.push_back(texture_rect)
		for key in shader_transition.end_params:
			tween.tween_property(texture_rect.material, "shader_parameter/" + key, shader_transition.end_params.get(key), shader_transition.durations.get(key)).from_current().set_trans(shader_transition.trans).set_ease(shader_transition.ease)

	tween.set_parallel(false)
	tween.tween_callback(_on_transition_in.bind(current, next, shader_ins))

func _on_transition_in(current: Node2D, next: String, shader_ins: Array[ShaderTransition]) -> void:
	if (next == ""):
		_cleanup_temps()
		return
		
	scene_container.add_child(load(next).instantiate())
	current.queue_free() # TODO: control whether to store in ScenePool OR free		
	
	var tween = self.create_tween()
	tween.set_parallel(true) # TODO: control parallel; chaining tweens

	for shader_transition in shader_ins:
		var back_buffer_copy: BackBufferCopy = BackBufferCopy.new()
		back_buffer_copy.copy_mode = BackBufferCopy.COPY_MODE_VIEWPORT
		scene_container.add_child(back_buffer_copy)
		var texture_rect: TextureRect = _create_shader(shader_transition)
		scene_container.add_child(texture_rect)
		temps.push_back(back_buffer_copy)
		temps.push_back(texture_rect)
		for key in shader_transition.end_params:
			tween.tween_property(texture_rect.material, "shader_parameter/" + key, shader_transition.end_params.get(key), shader_transition.durations.get(key)).from_current().set_trans(shader_transition.trans).set_ease(shader_transition.ease)
		
	tween.set_parallel(false)
	
	tween.tween_callback(_cleanup_temps)

func _cleanup_temps() -> void:
	for temp in temps:
		temp.queue_free()
	temps.clear()
