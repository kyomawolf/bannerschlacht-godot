extends Camera2D

var upMovement:bool=false
var downMovement:bool=false
var leftMovement:bool=false
var rightMovement:bool=false
var min_zoom:float = 0.5
var max_zoom:float = 2


func _setNewKeyforAction(actionName: String, actionKey: String) -> bool:
	var keyEvent = InputEventKey.new()
	var code = OS.find_keycode_from_string(actionKey)
	keyEvent.set_keycode(code)
	InputMap.action_add_event(actionName, keyEvent)
	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	_setNewKeyforAction("camera_up", "w")
	_setNewKeyforAction("camera_down", "s")
	_setNewKeyforAction("camera_left", "a")
	_setNewKeyforAction("camera_right", "d")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed('camera_up')):
		self.position.y -= 1000 * delta
	if (Input.is_action_pressed('camera_right')):
		self.position.x += 1000 * delta
	if (Input.is_action_pressed('camera_down')):
		self.position.y += 1000 * delta
	if (Input.is_action_pressed('camera_left')):
		self.position.x -= 1000 * delta

func _unhandled_input(event):
	if (event.is_action_pressed('zoom_in')):
		var zoomlevel = clamp(zoom.x - 0.1, min_zoom, max_zoom)
		print(zoomlevel)
		zoom = Vector2(zoomlevel, zoomlevel)
		scale = Vector2(1 / zoom.x, 1 / zoom.y)
	if (event.is_action_pressed('zoom_out')):
		var zoomlevel = clamp(zoom.x + 0.1, min_zoom, max_zoom)
		print(zoomlevel)
		zoom = Vector2(zoomlevel, zoomlevel)
		scale = Vector2(1 / zoom.x, 1 / zoom.y)

func set_zooms(delta: Vector2) -> void:
	var mouse_pos := get_global_mouse_position()
	$Camera2D.zoom += delta
	var new_mouse_pos := get_global_mouse_position()
	$Camera2D.position += mouse_pos - new_mouse_pos
