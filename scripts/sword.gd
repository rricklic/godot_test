extends Sprite2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_SPACE)):
		animation_player.play("animation_slash")

func _process(delta):
	pass
