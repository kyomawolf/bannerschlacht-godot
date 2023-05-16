extends Control

var build_mode = false
var move_mode = false
var speed = 10
var unit_mode=1
var selected = null
var ui = null
var cam : Camera2D = null
var once = false
var terrain = null
var visible_tiles = [] # Vector2i
var debug = false

var existing_units = [{"pos": Vector2i(-1, -1), "unit": null}]


# checks if field is empty
func tile_is_occupied(tile: Vector2i):
	for idx in existing_units:
		if idx["pos"] == tile:
			return true
	return false


# sets new unit on battlefield
func action_set_unit(tile_id, cell):
	if not tile_is_occupied(tile_id):
		var tile_node = get_parent().get_node("sampleGame")
		var unit_name = "res://ressources/units/base.tscn"
		if unit_mode == 2:
			unit_name = "res://ressources/units/base_enemy.tscn"
		var new_unit = load(unit_name).instantiate()
		new_unit.position = tile_id * 16
		if unit_mode != 1 and debug == false:
			new_unit.visible = false
		tile_node.add_child(new_unit, true)
		new_unit.player = unit_mode
		existing_units.append({"pos": tile_id, "unit": new_unit})
		# set tile 45, 29

# camera zoom
func camera_zoom():
	# zoom
	var input_zoom = Input.get_axis("camera_zoom_up", "camera_zoom_down")
	var curr_zoom = cam.zoom
	if input_zoom == 0:
		return
	# print(input_zoom, "  ", curr_zoom)
	if curr_zoom.x < 1.6 and input_zoom == -1:
		curr_zoom.x += 0.1
	elif curr_zoom.x >= 0.4 and input_zoom == 1:
		curr_zoom.x -= 0.1
	curr_zoom.y = curr_zoom.x
	cam.zoom = curr_zoom


# camera movement
func movement():
	var input_direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	var velocity = input_direction * speed
	cam.move_local_x(velocity[0])
	cam.move_local_y(velocity[1])


func game_mode():
	# click on units and then be able to  move them. If clicked on other unit, battle it
	if Input.is_action_just_released("mouse_left") and move_mode:
		if selected != null:
			var new_position = self.get_node("terrain").local_to_map(get_global_mouse_position())
			if !tile_is_occupied(new_position):
				selected["unit"].add_action_to_list("move", new_position)
				selected = null
		else:
			var tile_map = self.get_node("terrain")
			var tile_id = tile_map.local_to_map(get_global_mouse_position())
			print(tile_id)
			for entry in existing_units:
				if entry["pos"] == tile_id:
					print("unit found")
					var unit = entry["unit"]
					ui.render_unit(unit)
					selected = entry
					break
	if Input.is_action_just_released("mouse_right"):
		selected = null



# Called when the node enters the scene tree for the first time.
func _ready():
	ui = self.get_node("ui_layer").get_node("ingame_ui").get_node("main")
	cam = self.get_node("Camera2D")
	terrain = self.get_node("terrain")
	var next_button = ui.get_node("control").get_node("next_round")
	
	next_button.pressed.connect(self.next_round)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
# captures user input
func _process(delta):
	var scene_handler = get_parent()
	# check for exit game
	if Input.is_key_pressed(KEY_ESCAPE):
		scene_handler.print_tree()
		scene_handler.get_node("sampleGame").queue_free()
		scene_handler.get_node("MainMenu").set_process(true)
	# check for tile selection
	if Input.is_action_just_released("mouse_left") and build_mode:
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
	if Input.is_action_just_released("move_unit") and build_mode == false and move_mode == false:
		move_mode = true
	elif Input.is_action_just_released("move_unit") and build_mode and move_mode == true:
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


# main round process
# fow, enemy routines, events
func next_round():
	for entry in existing_units:
		if entry["unit"] != null:
			var new_pos = entry["unit"].get_next_action("move")
			if new_pos:
				entry["pos"] = new_pos
				entry["unit"].position = entry["pos"] * 16
			entry["unit"].flush_action_list()
		# do actions defined before (movement attack, etc)
	# calculate fog of war
	fog_of_war(1)
	
	
# checks the tiles that are made visible by friendly units
func add_visibles(origin: Vector2, length: int):
	print(origin)
	visible_tiles.append(Vector2i(origin))
	print(origin.x - length, " ", origin.y - length)
	print(origin.x + length, " ", origin.y + length)
	for i in range(origin.x - length, origin.x + length + 1):
		for ii in range(origin.y - length, origin.y + length + 1):
			if origin.distance_to(Vector2i(i, ii)) <= length:
				# print("in range", origin, Vector2i(i, ii), length)
				visible_tiles.append(Vector2i(i, ii))
			#else:
				#print("not in range", origin, Vector2i(i, ii), length)
		

# removes fow from visible fields and discovers enemy units
func fog_of_war(player):
	print(terrain.get_layers_count())
	for entry in existing_units:
		if entry["unit"] != null && \
		entry["unit"].player == player:
			print(entry, "unit added")
			add_visibles(entry["pos"], entry["unit"].sight)
	for idx in visible_tiles:
		print(idx)
		terrain.erase_cell(0, idx)
		for entry in existing_units:
			if entry['pos'] == idx:
				entry["unit"].visible = true
		#terrain.set_cell(1, idx, 0, Vector2i(0,0))

func _physics_process(_delta):
	movement()

func _input(_event):
	camera_zoom()
