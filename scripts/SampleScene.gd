extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# check for exit game
	if Input.is_key_pressed(KEY_ESCAPE):
		var scene_handler = get_parent()
		scene_handler.print_tree()
		scene_handler.get_node("sampleGame").queue_free()
		scene_handler.get_node("MainMenu").set_process(true)
	# check for tile selection
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var tile_node = get_parent()
		var tile_map = tile_node.get_node("terrain").get_class()
		var tile_id =  tile_map.local_to_map(get_global_mouse_position())
		print(tile_id)
