extends ColorRect

signal signal_retry
signal signal_next

@onready var retry_button: Button = %RetryButton
@onready var next_level_button: Button = %NextLevelButton

func _ready() -> void:
	retry_button.grab_focus()
	visibility_changed.connect(_grab_focus)
	retry_button.pressed.connect(_retry_level)
	next_level_button.pressed.connect(_goto_next_level)

func _grab_focus() -> void:
	retry_button.grab_focus()

func _retry_level() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	signal_retry.emit()
	visible = false

func _goto_next_level() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	signal_next.emit()
	visible = false
