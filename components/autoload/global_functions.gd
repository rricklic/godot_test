extends Node2D

################################################################################
# Description: 
################################################################################

func get_window_size() -> Vector2:
	return get_tree().root.size
	
func get_viewport_size() -> Vector2:
	return get_viewport_rect().size
