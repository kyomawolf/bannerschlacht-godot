extends Control

var vboxcontainer
var hboxcontainer

var sigClicked:Signal


# Called when the node enters the scene tree for the first time.
func _ready():
	return
	vboxcontainer = VBoxContainer.new()
	self.add_child(vboxcontainer)
	hboxcontainer = HBoxContainer.new()
	vboxcontainer.add_child(hboxcontainer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.get_button_index() == MOUSE_BUTTON_LEFT and event.is_pressed():
		mouseEvent()

func mouseEvent():
	print("called")
	sigClicked.emit()

func giveMeSignal() -> Signal:
	return sigClicked
