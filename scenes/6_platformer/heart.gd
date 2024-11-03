class_name Heart extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area2D: Area2D) -> void:
	queue_free()
	var num_hearts: int = get_tree().get_nodes_in_group("hearts").size()
	if (num_hearts <= 1):
		GlobalSignals.signal_level_completed.emit() 
