extends Node

################################################################################
# Description: 
#
# Use: Set as Autoload (Project -> Project Settings -> Autoload)
################################################################################

signal signal_transition_file(scene_path: String)
signal signal_transition_packed_scene(packed_scene: PackedScene)

var current_scene: Node

func set_current_scene(current_scene: Node):
	self.current_scene = current_scene

func _ready():
	signal_transition_file.connect(_transition_scene_file)
	signal_transition_packed_scene.connect(_transition_scene_packed_scene)
		
func _transition_scene_file(scene_path: String) -> void:
	await _transition_out()
	var next_scene: Node = _create_scene_from_file(scene_path) 
	_switch_scene(next_scene)
	await _transition_in()

func _transition_scene_packed_scene(packed_scene: PackedScene) -> void:
	await _transition_out()
	var next_scene: Node = _create_scene_from_packed_scene(packed_scene)
	_switch_scene(next_scene)
	await _transition_in()

func _transition_out() -> void:
	await LevelTransition.fade_to_black()

func _create_scene_from_file(scene_path: String) -> Node:
	var packed_scene: PackedScene = load(scene_path)
	return _create_scene_from_packed_scene(packed_scene)

func _create_scene_from_packed_scene(packed_scene: PackedScene) -> Node:
	return packed_scene.instantiate() 

func _switch_scene(next_scene: Node) -> void:
	if (current_scene):
		current_scene.queue_free()
	else:
		get_tree().current_scene.queue_free()
	current_scene = next_scene
	get_tree().root.add_child(current_scene)

func _transition_in() -> void:
	await LevelTransition.fade_from_black()
