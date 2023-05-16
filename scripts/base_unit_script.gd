extends Node

enum direction{north, east, south, west}

var health = 100
var attack = 10
var defense = 5
var facing = direction.north
var hidden = false
var speed = 1
var moral = 10
var target = Vector2i(-1, -1)
var player = 0
var sight = 2

var action_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func base_actions():
	pass

func path_finder(start: Vector2i, end: Vector2i):
	pass


func get_player():
	return player

func get_next_action(name):
	for action in action_list:
		if action == null:
			return
		if action["name"] == name:
			return action["value"]

func add_action_to_list(name: String, value):
	action_list.append({"name": name, "value": value})

func flush_action_list():
	action_list.clear()
