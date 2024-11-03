class_name MainPlatformer extends Node2D

func _enter_tree() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	SceneMgr.set_current_scene($StartMenu)
	# Set root viewport size
	get_tree().root.content_scale_size = Vector2i(320, 180)
	# Set scale mode - pixelate
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS 
	 # Set canvas texures default texture fileter - pixelate
	get_tree().root.canvas_item_default_texture_filter = Window.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	# Set window size
	DisplayServer.window_set_size(Vector2i(1280, 720))
