extends Node2D

@onready var screen_container: Control = $SceneManager/SceneContainer
func _ready():
	# TODO: how to change viewport size in code?
	#var viewport = get_tree().root.get_viewport()
	#viewport.set = Vector2(1900, 1200)
	
	var scene = load("res://scenes/1_prologue_scene/prologue.tscn").instantiate()
	screen_container.add_child(scene)
