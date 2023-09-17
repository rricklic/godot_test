extends MarginContainer

class_name Dialogue

const MAX_WIDTH: int = 256

var text: String = "The quick brown fox jumps over the lazy dog"
var text_index: int = 0

@export var time_letter: float = 0.05
@export var time_space: float = 0.01
@export var time_punct: float = 0.05

signal signal_finished(dialogue: Dialogue)

@onready var timer: Timer = $Timer
@onready var label: Label = $MarginContainer/Label
@onready var completedIcon: Polygon2D = $CompletedIcon

func _ready() -> void:
	self.timer.timeout.connect(_next_letter)
	#display_text("This is a test string for the purpose of seeing how this dialogue box works. If it is not very good we can always make it better.")

func display_text(text: String):
	self.text = text
	self.label.text = text
	await resized # TODO: just connect the signal?
	self.custom_minimum_size.x = min(self.size.x, MAX_WIDTH)
	if (self.size.x > MAX_WIDTH):
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		#await resized # x resize # TODO:
		#await resized # y resize # TODO:
		self.custom_minimum_size.y = size.y
		
	#self.global_position.x -= size.x / 2
	#self.global_position.y -= size.y + 24
	self.label.text = ""
	_display_letter()
	
func _display_letter() -> void:
	self.label.text += self.text[self.text_index]
	self.text_index += 1
	if (self.text.length() <= self.text_index):
		signal_finished.emit(self)
		completedIcon.visible = true
		completedIcon.position = self.size - Vector2(20, 20)
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_loops()
		tween.tween_property(completedIcon, "position", Vector2(completedIcon.position.x, completedIcon.position.y - 5), 1).from(self.completedIcon)
		tween.tween_property(completedIcon, "position", Vector2(completedIcon.position.x, completedIcon.position.y + 5), 1).from(self.completedIcon)
		return
		
	match self.text[self.text_index]:
		"!", ".", "?", ",", ";":
			self.timer.start(self.time_punct)
		" ", "\t":
			self.timer.start(self.time_space)
		_:
			self.timer.start(self.time_letter)

func _next_letter() -> void:
	_display_letter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
