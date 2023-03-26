extends Control

var build_mode = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func action_set_unit(tile_id, cell):
	if !cell:
		var tile_node = get_parent().get_node("sampleGame")
		var new_unit = load("res://ressources/units/base.tscn").instantiate()
		new_unit.position = tile_id * 16
		tile_node.add_child(new_unit, true)
		var index = [0,0]
		tile_node.get_node("clickable").set_cell(0, tile_id, -1, index, 0)
	

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
		var tile_map = tile_node.get_node("sampleGame").get_node("terrain")
		var prop_map = tile_node.get_node("sampleGame").get_node("clickable")
		print(tile_node)
		print(tile_map)
		var tile_id = tile_map.local_to_map(get_global_mouse_position())
		var prop = prop_map.local_to_map(get_global_mouse_position())
		print(tile_id, prop, prop_map)
		if build_mode:
			action_set_unit(prop, prop_map.get_cell_tile_data(0, prop))
	# enter|exit build mode
	if Input.is_key_pressed(KEY_B):
		if build_mode:
			build_mode = false
		else:
			build_mode=true
