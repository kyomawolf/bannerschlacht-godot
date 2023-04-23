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
