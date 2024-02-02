extends Node2D

var ice_cream_scene: Resource = preload("res://test/ice_cream_proto/ice_cream.tscn")

var score: int = 0

################################################################################
@onready var cone: Cone = $Cone
@onready var timer: Timer = $Timer
@onready var pattern = $Pattern
@onready var score_label: Label = $Score
func _ready() -> void:
	timer.timeout.connect(_drop_ice_cream)
	score_label.text = str(score);

################################################################################
func _drop_ice_cream() -> void:	
	var ice_cream: Area2D = ice_cream_scene.instantiate()
	add_child(ice_cream)
	ice_cream.area_entered.connect(cone.attach_ice_cream.bind(ice_cream))
	#ice_cream.signal_catch.connect(_on_ice_cream_catch)
	#ice_cream.signal_miss.connect(_on_ice_cream_miss)
	#timer.wait_time = randf_range(0, 3)

func _physics_process(delta: float) -> void:
	if pattern.colors.size()+2 == cone.get_child_count():
		if pattern.check_colors(cone.get_children()):
			score += 1
		else:
			score -= 1
		score_label.text = str(score);
		cone.remove_ice_cream()
		pattern.randomize_colors(3)
