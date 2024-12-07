extends Node2D

var tilemapData:TileMap
var tilemapTerrainData = []
var tilemapTerrainHeight = 0
var tilemapTerrainWidth = 0
var tileGrass = Vector2i(10, 15)
var tileWater = Vector2i(9, 15)
var tileHill = Vector2i(11, 15)

var unitList = []
var selectedUnit

var unitTest

var bannerschlachtDirectory:String

func _setNewKeyforAction(actionName: String, actionKey: String) -> bool:
	var keyEvent = InputEventKey.new()
	var code = OS.find_keycode_from_string(actionKey)
	keyEvent.set_keycode(code)
	InputMap.action_add_event(actionName, keyEvent)
	return true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	unitTest = preload("res://UnitTile.tscn")
	var mouseEvent = InputEventMouseButton.new()
	mouseEvent.set_button_index(MOUSE_BUTTON_LEFT)
	InputMap.action_add_event("mouse_click_left", mouseEvent)
	mouseEvent.set_button_index(MOUSE_BUTTON_RIGHT)
	InputMap.action_add_event("mouse_click_right", mouseEvent)
	
	var retVal = []
	bannerschlachtDirectory = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	bannerschlachtDirectory += "/bannerschlacht"
	if (OS.execute("ls", [bannerschlachtDirectory], retVal) != 0):
		if (OS.execute("mkdir", [bannerschlachtDirectory]) == 1):
			print("cannot save file, target directory could not be created")
	
	tilemapData = self.find_child("TileMap")
	var mapName = "mapfile.csv"
	var openFile = FileAccess.open(bannerschlachtDirectory + "/" + mapName, FileAccess.READ)
	if (!openFile):
		return
	var allText = openFile.get_as_text()
	parseMap(allText)
	openFile.close()
	pass # Replace with function body.

func parseMap(text:String):
	text = text.replace(",", "")
	var arr = text.split('\n', false)
	var lineCounter = 0
	for idx in arr:
		var charCounter = 0
		for character in idx:
			if character == "1":
				tilemapData.set_cell(0, Vector2i(lineCounter, charCounter), 0, tileWater)
			else:
				tilemapData.set_cell(0, Vector2i(lineCounter, charCounter), 0, tileGrass)
			charCounter += 1
		tilemapTerrainData.append(idx)
		lineCounter += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _input(event):
	if event is InputEventMouseButton and event.get_button_index() == MOUSE_BUTTON_LEFT:
		mousePressedHandle(event)

func gridClicked(globalPos:Vector2) -> bool:
	var localPos:Vector2i = tilemapData.to_local(globalPos)
	var tileData = tilemapData.get_cell_tile_data(0, tilemapData.local_to_map(localPos))
	if (tileData):
		return true
	return false

func getTileFromGlobal(globalPos:Vector2) -> TileData:
	return  tilemapData.get_cell_tile_data(0, tilemapData.local_to_map(tilemapData.to_local(globalPos)))

func getTileIndex(globalPos:Vector2) -> Vector2i:
	return tilemapData.local_to_map(globalPos)

func selectUnit(clickPosition:Vector2i):
	
	pass 


func mousePressedHandle(event:InputEventMouseButton):
	var mousePosition:Vector2 = event.position
	
	if (gridClicked(mousePosition)):
		print("clicked on Map")
		print(getTileIndex(mousePosition))
		selectUnit(getTileIndex(mousePosition))


func createNewUnit():
	var instance = unitTest.instantiate()
	self.add_child(instance)
	#tile size times position
	instance.position.x = 16 * 12
	instance.position.y = 16 * 12

