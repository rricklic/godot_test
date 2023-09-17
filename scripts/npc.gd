extends StaticBody2D

const DIALOGUE_TEXT: String = "Hello, world!"
var is_entered: bool = false

@onready var area2D: Area2D = $Area2D
func _ready():
	area2D.body_entered.connect(_on_body_entered)
	area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(player: Player) -> void:
	is_entered = true

func _on_body_exited(player: Player) -> void:
	is_entered = false

func _unhandled_key_input(event: InputEvent) -> void:
	if (self.is_entered && Input.is_key_pressed(KEY_E)):
		DialogueManager.display(self.DIALOGUE_TEXT, self.position)	
