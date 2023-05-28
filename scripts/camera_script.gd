extends Camera2D

# load from settings
var speed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
#	var lower_right = get_parent().get_node("terrain").get_used_rect().size
#	self.limit_top = 0
#	self.limit_left = 0
#	self.limit_bottom = lower_right.y
#	self.limit_right = lower_right.x
#	print(lower_right)
#	print (self.limit_bottom)
#	print (self.limit_right)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	movement()

# camera zoom
func camera_zoom():
	# zoom
	var input_zoom = Input.get_axis("camera_zoom_up", "camera_zoom_down")
	var curr_zoom = self.zoom
	if input_zoom == 0:
		return
	# print(input_zoom, "  ", curr_zoom)
	if curr_zoom.x < 1.6 and input_zoom == -1:
		curr_zoom.x += 0.1
	elif curr_zoom.x >= 0.4 and input_zoom == 1:
		curr_zoom.x -= 0.1
	curr_zoom.y = curr_zoom.x
	self.zoom = curr_zoom


# camera movement
func movement():
	var input_direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	var velocity = input_direction * speed
	print(self.position, velocity)
	if self.position.x + velocity[0] >= self.limit_left and self.position.x + velocity[0] <= self.limit_right:
		self.move_local_x(velocity[0])
	if self.position.y + velocity[1] >= self.limit_top and self.position.y + velocity[1] <= self.limit_bottom:
		self.move_local_y(velocity[1])


func _input(_event):
	camera_zoom()
