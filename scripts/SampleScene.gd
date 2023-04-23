extends Control

var build_mode = false
var speed = 10
var unit_mode=1
var selected = null
var ui = null
var cam : Camera2D = null
var once = false
var visible_tiles = [] # Vector2i

var existing_units = [{"pos": Vector2i(-1, -1), "unit": null}]

func action_set_unit(tile_id, cell):
	if !(tile_id in existing_units):
		var tile_node = get_parent().get_node("sampleGame")
		var unit_name = "res://ressources/units/base.tscn"
		if unit_mode == 2:
			unit_name = "res://ressources/units/base_enemy.tscn"
		var new_unit = load(unit_name).instantiate()
		new_unit.position = tile_id * 16
		tile_node.add_child(new_unit, true)
		existing_units.append({"pos": tile_id, "unit": new_unit})
		new_unit.player = unit_mode
		# set tile 45, 29


func camera_zoom():
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
	# move
	var input_direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	var velocity = input_direction * speed
	cam.move_local_x(velocity[0])
	cam.move_local_y(velocity[1])


func game_mode():
	# click on units and then be able to  move them. If clicked on other unit, battle it
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		once = true
		if selected != null:
			selected.target = self.get_node("terrain").local_to_map(get_global_mouse_position())
			print("moving...")
		else:
			var tile_map = self.get_node("terrain")
			var tile_id = tile_map.local_to_map(get_global_mouse_position())
			for entry in existing_units:
				if entry["pos"] == tile_id:
					print("unit found")
					var unit = entry["unit"]
					ui.render_unit(unit)
					selected = unit
					break
	elif !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		once = false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		selected = null



# Called when the node enters the scene tree for the first time.
func _ready():
	ui = self.get_node("ui_layer").get_node("ingame_ui").get_node("main")
	cam = self.get_node("Camera2D")
	var next_button = ui.get_node("control").get_node("next_round")
	next_button.pressed.connect(self.next_round)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scene_handler = get_parent()
	# check for exit game
	if Input.is_key_pressed(KEY_ESCAPE):
		scene_handler.print_tree()
		scene_handler.get_node("sampleGame").queue_free()
		scene_handler.get_node("MainMenu").set_process(true)
	# check for tile selection
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and build_mode:
		var tile_node = get_parent()
		var tile_map = tile_node.get_node("sampleGame").get_node("terrain")
		var prop_map = tile_node.get_node("sampleGame").get_node("clickable")
		print(tile_node)
		print(tile_map)
		var tile_id = tile_map.local_to_map(get_global_mouse_position())
		var prop = prop_map.local_to_map(get_global_mouse_position())
		print(tile_id, prop, prop_map)
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

func next_round():
	for entry in existing_units:
		if entry["unit"] == null:
			continue
		# do actions defined before (movement attack, etc)
	# calculate fog of war
	add_visibles(Vector2i(2, 2), 3)

func add_visibles(origin: Vector2, length: int):
	for i in range(origin.x - length, origin.x + length + 1):
		for ii in range(origin.y - length, origin.y + length + 1):
			if origin.distance_to(Vector2i(i, ii)) <= length:
				print("in range", origin, Vector2i(i, ii), length)
			else:
				print("not in range", origin, Vector2i(i, ii), length)
				# visible_tiles.append(Vector2i(i, ii))
		

func fog_of_war(player):
	for entry in existing_units:
		if entry["unit"].player == player:
			add_visibles(entry["unit"].position, entry["unit"].sight)

func _physics_process(_delta):
	movement()

func _input(_event):
	camera_zoom()
