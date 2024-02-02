class_name Health extends Object

################################################################################
# Description: Tracks health and signals on health change
################################################################################

signal signal_health_change(amount: float)

var max_health: float:
	set(amount):
		max_health = amount
	get: 
		return max_health

var health: float:
	set(amount):
		health = amount
		if (health > max_health):
			health = max_health
	get: 
		return health

func _init(max_health: float) -> void:
	self.max_health = max_health
	self.health = max_health

func adjust(amount: float) -> void:
	health += amount
	signal_health_change.emit(health)
