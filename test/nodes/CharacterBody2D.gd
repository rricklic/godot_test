extends CharacterBody2D

func _physics_process(delta: float) -> void:
	self.global_position = get_global_mouse_position()
	# move_and_slide()
