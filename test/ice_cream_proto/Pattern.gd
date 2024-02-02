class_name Pattern
extends Node2D

var colors: Array[Color]
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	randomize_colors(3)

func randomize_colors(num_colors: int) -> void:
	colors.clear()
	for i in range(0, num_colors):
		colors.append(IceCream.colors[rng.randi_range(0, IceCream.colors.size()-1)])
	queue_redraw()

func _draw() -> void:
	for i in range(0, colors.size()):
		draw_rect(Rect2(0, 40 - i * 20, 20, 20), colors[i], true)

func check_colors(nodes: Array[Node]) -> bool:
	for i in colors.size():
		var polygon2D: Polygon2D = nodes[i+2].get_node("Polygon2D")
		if colors[i] != polygon2D.get_color():
			return false
	return true
