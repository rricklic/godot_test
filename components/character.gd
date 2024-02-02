extends CharacterBody2D



const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


@export var SPEED: float = 200.0
func _physics_process(delta: float) -> void:
	
	
	
	
	
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("player1_left", "player1_right")
	input_vector.y = Input.get_axis("player1_up", "player1_down")
	input_vector = input_vector.normalized()
	velocity = lerp(velocity, input_vector * SPEED, 0.05)
	
	var rotate_amount: float = Input.get_axis("player1_left", "player1_right") * 15
	rotation_degrees = lerp(rotation_degrees, rotate_amount, 0.05)



	move_and_slide()
