extends Node2D

class_name Circle

var radius: float = 5.0
var color: Color = Color.WHITE

# Called when class is ready
func _init(position: Vector2) -> void:
	self.position = position

func _draw()-> void:
	self.draw_circle(self.position, self.radius, self.color)

func update_position(position: Vector2)-> void:
	self.position = position
	queue_redraw()
