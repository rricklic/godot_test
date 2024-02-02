class_name Cone
extends Area2D

const SPEED: float = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("ui_left", "ui_right")
	global_position.x += direction * SPEED * delta

func attach_ice_cream(area2D: Area2D, ice_cream: IceCream) -> void:
	ice_cream.is_falling = false
	ice_cream.reparent(self)

func remove_ice_cream() -> void:
	for node: Node in get_children():
		if node is IceCream:
			node.queue_free()
			remove_child(node)
