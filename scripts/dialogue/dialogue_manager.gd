extends Node2D

const DIALOGUE_SCENE: PackedScene = preload("res://scenes/dialogue/dialogue.tscn")

var is_active: bool = false
var is_finished: bool = false
var dialogue: Dialogue = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _create_dialogue(text: String, position: Vector2) -> void:
	dialogue = DIALOGUE_SCENE.instantiate()
	dialogue.signal_finished.connect(_on_finished)
	get_tree().root.add_child(dialogue)
	dialogue.display_text(text)
	dialogue.position = position

func display(text: String, position: Vector2) -> void:
	if (self.is_active):
		return

	_create_dialogue(text, position)
	self.is_active = true
	self.is_finished = false

func _cleanup() -> void:
	if (!self.is_finished):
		return
	
	self.dialogue.queue_free()
	self.dialogue = null
	self.is_active = false
	self.is_finished = false

func _on_finished(dialogue: Dialogue) -> void:
	self.is_finished = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_key_input(event: InputEvent):
	if (event.pressed && event.keycode == KEY_E && self.is_active && self.is_finished):
		_cleanup()
