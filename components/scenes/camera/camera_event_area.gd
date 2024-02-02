class_name CameraEventArea extends Area2D

################################################################################
# Description: 
################################################################################

@export var target: Node2D 

func _ready() -> void:
	area_entered.connect(_camera_entered)
	area_exited.connect(_camera_exited)

func set_target(node2D: Node2D) -> void:
	self.target = node2D

func _camera_entered(area2D: Area2D) -> void:
	if (area2D is CameraEx2D):
		var camera: CameraEx2D = area2D
		camera.add_target(target)

func _camera_exited(area2D: Area2D) -> void:
	if (area2D is CameraEx2D):
		var camera: CameraEx2D = area2D
		camera.remove_target(target)
