extends Node2D

@export var file_path: String = "user://test_data.dat" #/home/rricklic/test_file" # "res://test_file_2", "user://test_file_3"
@export var io: FileAccess.ModeFlags = FileAccess.READ

var dict: Dictionary = {
	"Megan" : 1,
	"Ryan" : 11,
	"Anna" : 12,
	"William" : 6
}

# ~/.local/share/godot/app_userdata

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Read file	
	var file = FileAccess.open(file_path, io)
	while (!file.eof_reached()) :
		var line = file.get_line()
		print(line);
	#var dict = parse_json(file.get_line())
	file.close()
	
	# Write file
	var json = JSON.new()
	file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_line(json.stringify(dict))
	file.close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass
	
func _notification(what):
	pass
