extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_game_button = get_node("MainMenu/TextureRect/MarginContainer/VBoxContainer/NewGame")
	var exit_game_button = get_node("MainMenu/TextureRect/MarginContainer/VBoxContainer/ExitGame")
	new_game_button.pressed.connect(self.on_new_game_pressed)
	exit_game_button.pressed.connect(self.on_quit_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_new_game_pressed():
#	get_node("MainMenu").queue_free()
	get_node("MainMenu").set_process(false)
	var game_scene = load("res://scenes/sample_scene.tscn").instantiate()
	add_child(game_scene)


func on_quit_pressed():
	get_tree().quit()
