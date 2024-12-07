extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var demo = Button.new()
	var mapgenerator = Button.new()
	var exit = Button.new()
	demo.text = "Demo"
	mapgenerator.text = "MapGenerator"
	exit.text = "Exit"
	demo.pressed.connect(self._buttonDemo)
	mapgenerator.pressed.connect(self._buttonMapGenerator)
	exit.pressed.connect(self._buttonExit)
	add_child(demo)
	add_child(mapgenerator)
	add_child(exit)


func _buttonDemo():
	var sceneTree = get_tree()
	var newScene = preload("res://demo.tscn")
	sceneTree.change_scene_to_packed(newScene)

func _buttonMapGenerator():
	var sceneTree = get_tree()
	var newScene = preload("res://MapGenerator.tscn")
	sceneTree.change_scene_to_packed(newScene)

func _buttonExit():
	var sceneTree = get_tree()
	sceneTree.quit(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
