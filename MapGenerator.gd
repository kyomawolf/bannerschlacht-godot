extends Node2D

var mapObject:GameMap

var fastNoiseObject = FastNoiseLite.new()
var texture:ImageTexture
var image:Image
var tileheight = []
var bannerschlachtDirectory = ""

# first version of map generate is using the defult fastnoise generator
# though this generator is easy to use, I would like to have more variety and specific landfeatures
# this could be achieved with a incremental generator, using steps large features->specific features->details
# this can also be useful for generating campaign maps, though I might want to use custom maps for this


# Called when the node enters the scene tree for the first time.
func _ready():
	var vBoxButtons:VBoxContainer = find_child("VBoxButtons")
	var generateText:Button = Button.new()
	generateText.text = "Generate Noise Texture"
	generateText.pressed.connect(self._buttonGenerateTexture)
	vBoxButtons.add_child(generateText)
	var generateMapFromText:Button = Button.new()
	generateMapFromText.text = "Generate Map"
	generateMapFromText.pressed.connect(self._buttonGenerateMap)
	vBoxButtons.add_child(generateMapFromText)
	var saveGeneratedMap:Button = Button.new()
	saveGeneratedMap.text = "Save Map"
	bannerschlachtDirectory = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	bannerschlachtDirectory += "/bannerschlacht"
	var retVal = []
	if (OS.execute("ls", [bannerschlachtDirectory], retVal) != 0):
		if (OS.execute("mkdir", [bannerschlachtDirectory]) == 1):
			print("cannot save file, target directory could not be created")
	saveGeneratedMap.pressed.connect(self._buttonSaveGeneratedMap)
	vBoxButtons.add_child(saveGeneratedMap)
	

func _2Dto1DCoordinate(x:int, y:int, maxSizeX:int) -> int:
	return (x*maxSizeX + y)

func _1Dto2DCoordinate(index:int, maxSizeX:int) -> Vector2i:
	return Vector2i(floor(index / maxSizeX), index % maxSizeX)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#texture.draw(, Vector2(0, 0) )

func _buttonGenerateMap():
	var pixel:Color
	if (image == null):
		_buttonGenerateTexture()
	var maxSize = image.get_size()
	for x in range(0, maxSize.x):
		for y in range(0,maxSize.y):
			pixel = image.get_pixel(x, y)
			tileheight.insert(_2Dto1DCoordinate(x, y, maxSize.x), floor(pixel.g * 10) )
	#print(tileheight)

func _popupErrorBox(error:String):
	return
	# todo whatever (maybe dont go as fancy and just do some canvas painting :( ) 
	var newWindow = AcceptDialog.new()
	newWindow.dialog_text = "Error cannot save file: " + error
	newWindow.title = "Error"
	self.get_parent().add_child(newWindow)
	return
	
	
	self.add_sibling(newWindow)
	newWindow.popup_centered(Vector2i(200, 100))
	var hbox = HBoxContainer.new()
	var textBox = TextLine.new()
	textBox.add_string("Error cannot save file: " + error, SystemFont.new(), 12)
	var buttonOk = Button.new()
	buttonOk.text = "Close"
	hbox.add(textBox)
	hbox.add(buttonOk)
	newWindow.add_child(hbox)

func _generateGeneralMapData(saveFile:FileAccess) -> String:
	#mapsizedata
	var sizeData = image.get_size()
	print(sizeData)
	var returnString:String = "x"
	returnString += String.num_int64(sizeData.x)
	returnString += "y"
	returnString += String.num_int64(sizeData.y)
	print(returnString)
	
	#mapheightdata
	returnString += " "
	for idx in tileheight:
		returnString += String.num(idx)
		returnString += " " 
	return returnString

func _generateHeightMap() -> String:
	return ""

func _generateDataMap() -> String:
	return ""

func _buttonSaveGeneratedMap():
	var saveGameName = "newGame.ban" 
	
	var saveFile = FileAccess.open(bannerschlachtDirectory + "/" + saveGameName, FileAccess.WRITE_READ)
	if (saveFile == null):
		var error:String = error_string(FileAccess.get_open_error())
		print("Error occured while opening the File: ", error)
		_popupErrorBox(error)
		return
	saveFile.store_string(_generateGeneralMapData(saveFile))
	print("done")


func _buttonGenerateTexture():
	fastNoiseObject.seed = randi()
	fastNoiseObject.frequency = 0.0008 #0.01
	fastNoiseObject.domain_warp_frequency = 0.1 # 0.05
	fastNoiseObject.fractal_octaves = 15 #5
	fastNoiseObject.domain_warp_fractal_octaves = 15 #5

	image = fastNoiseObject.get_image(1000, 1000, false, false, true)
	print(image.get_width(), image.get_height())
	texture = ImageTexture.create_from_image(image)
	var child:TextureRect = find_child("TextureRect")
	if (child == null):
		print("not found")
		return
	child.texture = texture
