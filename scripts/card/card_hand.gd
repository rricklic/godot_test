extends Node2D

@export var curve_hand_width: Curve
@export var curve_hand_height: Curve
@export var curve_hand_rotation: Curve

const card_scene: PackedScene = preload("res://scenes/cards/card.tscn")

var cards: Array[Card]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
func _ready():
	add_card()

	_set_card_positions()
	animation_player.play("bob")

func add_card(): # card: Card # TODO:
	var card: Card = card_scene.instantiate()
	card.position = Vector2(2000.0, 600.0)
	card.rotation_degrees = 0.0
	cards.append(card)
	self.add_child(card)	
	
func _set_card_positions() -> void:	
	var i: int = 0
	var n: int = self.cards.size()
	for card in self.cards:
		_set_card_position(card, i, n)
		i += 1

func _set_card_position(card: Card, i: int, n: int) -> void:
	var card_weight: float = 0.5 if n <= 1 else float(i) / float(n - 1)
	var new_x = self.position.x + curve_hand_width.sample(card_weight) * min(n * 70.0, 525.0)
	var new_y = self.position.y - curve_hand_height.sample(card_weight) * min(n * 10.0, 100.0)
	var new_rotation = -15.0 * curve_hand_rotation.sample(card_weight)

	var tween = self.create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_parallel(true)
	tween.tween_property(card, "position", Vector2(new_x, new_y), 0.2).from(card.position)
	tween.tween_property(card, "rotation_degrees", new_rotation, 0.2).from(card.rotation_degrees)
	tween.set_parallel(false)


func remove_card(): # TODO: card: Card
	var card: Card = cards.pop_back() # TODO:
	if (card != null):
		card.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_A)):
		self.add_card()
		_set_card_positions()
		
	if (Input.is_key_pressed(KEY_R)):
		self.remove_card()
		_set_card_positions()
