extends Node

################################################################################
# Description: 
#
# Use: Set as Autoload (Project -> Project Settings -> Autoload)
################################################################################

signal signal_transition(
		scene_path: String,
		transition_out: Array[SceneTransitionShader.Transition],
		transition_in: Array[SceneTransitionShader.Transition],
		is_free_old_scene: bool)

const GROUP: String = "SceneManagerGroup"

# Scene name (String) -> scene (Node)
var scene_pool: Dictionary

func _ready():
	signal_transition.connect(_transition_scene)
	
func _transition_scene(
		scene_path: String,
		transition_outs: Array[SceneTransitionShader],
		transition_ins: Array[SceneTransitionShader],
		is_free_old_scene: bool = true
		) -> void:
	_transition(transition_outs, _transition_in.bind(scene_path, transition_ins, is_free_old_scene))

func _transition(
		transitions: Array[SceneTransitionShader],
		callable: Callable
		) -> void:
	var tween = self.create_tween()
	tween.set_parallel(true)
	for transition in transitions:
		transition.start(self, tween)
	tween.set_parallel(false)
	tween.tween_callback(callable)
	tween.play()

func _transition_in(
		scene_path: String,
		transition_ins: Array[SceneTransitionShader],
		is_free_old_scene: bool
		) -> void:
	_cleanup()
	
	var new_scene: Node
	if (scene_pool.has(scene_path)):
		new_scene = scene_pool.get(scene_path)
		scene_pool.erase(scene_path)
	else:
		var packed_schene: PackedScene = load(scene_path) # TODO: load via thread
		new_scene = packed_schene.instantiate()	
	
	# TODO: wait for packed_schene to load; instantiate; show optional progress bar
	# TODO: pass data from old_scene to new_scene
	
	var old_scene: Node = get_tree().current_scene
	if (is_free_old_scene):
		old_scene.queue_free()
	else:
		scene_pool[old_scene.scene_file_path] = old_scene
		get_tree().root.remove_child(old_scene)

	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	_transition(transition_ins, _cleanup)

"""
func _load_scene(resource: String) -> Node:
	var packed_scene: PackedScene = load(resource)
	return packed_scene.instantiate()

func _load_scene_threaded(resource: String) -> Node:
	var error: Error = ResourceLoader.load_threaded_request(resource)
	var progress: Array
	while true:
		var load_status: ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(resource, progress)
		match load_status:
			ResourceLoader.THREAD_LOAD_FAILED:
				break
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				break
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				print("progress = " + str(progress[0]))
			ResourceLoader.THREAD_LOAD_LOADED:
				var packed_scene: PackedScene = ResourceLoader.load_threaded_get(resource)
				return packed_scene.instantiate()
	return null
"""

func _cleanup() -> void:
	for node: Node in get_tree().get_nodes_in_group(GROUP):
		node.queue_free()
