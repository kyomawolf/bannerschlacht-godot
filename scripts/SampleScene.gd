extends Control

var build_mode = false
var speed = 10
var unit_mode=1

var existing_units = [Vector2i(-1, -1)]

func action_set_unit(tile_id, cell):
	if !(tile_id in existing_units):
		var tile_node = get_parent().get_node("sampleGame")
		var unit_name = "res://ressources/units/base.tscn"
		if unit_mode == 2:
			unit_name = "res://ressources/units/base_enemy.tscn"
		var new_unit = load(unit_name).instantiate()
		new_unit.position = tile_id * 16
		tile_node.add_child(new_unit, true)
		existing_units.append(tile_id)
		# build_mode = false

func camera_zoom():
	var cam : Camera2D = get_parent().get_camera_2d()
	# zoom
	var input_zoom = Input.get_axis("camera_zoom_up", "camera_zoom_down")
	var curr_zoom = cam.zoom
	if input_zoom == 0:
		return
	print(input_zoom, "  ", curr_zoom)
	if curr_zoom.x < 1.6 and input_zoom == -1:
		curr_zoom.x += 0.1
	elif curr_zoom.x >= 0.4 and input_zoom == 1:
		curr_zoom.x -= 0.1
	curr_zoom.y = curr_zoom.x
	cam.zoom = curr_zoom


func movement():
	var scene_handler = get_parent()
	var cam : Camera2D = scene_handler.get_camera_2d()
	# move
	var input_direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	var velocity = input_direction * speed
	cam.move_local_x(velocity[0])
	cam.move_local_y(velocity[1])

func game_mode():
	# click on units and then be able to  move them. If clicked on other unit, battle it
	#if Input.mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scene_handler = get_parent()
	# check for exit game
	if Input.is_key_pressed(KEY_ESCAPE):
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
	if Input.is_action_just_released("enter_build_mode") and build_mode == false:
		build_mode = true
	elif Input.is_action_just_released("enter_build_mode") and build_mode == true:
		build_mode = false
	if not build_mode:
		game_mode()
		return
	if Input.is_action_just_released("num_1"):
		unit_mode = 1
		print(unit_mode)
	elif Input.is_action_just_released("num_2"):
		unit_mode = 2
		print(unit_mode)
func _physics_process(_delta):
	movement()

func _input(_event):
	camera_zoom()
