extends Node
class_name GameMap

var heightMap = []
var image:Image

func _2Dto1DCoordinate(x:int, y:int, maxSizeX:int) -> int:
	return (x*maxSizeX + y)

func _1Dto2DCoordinate(index:int, maxSizeX:int) -> Vector2i:
	return Vector2i(floor(index / maxSizeX), index % maxSizeX)


func new(newImage:Image):
	if (image == null):
		return null
	image = newImage
	var pixel:Color
	var maxSize = image.get_size()
	for x in range(0, maxSize.x):
		for y in range(0,maxSize.y):
			pixel = image.get_pixel(x, y)
			heightMap.insert(_2Dto1DCoordinate(x, y, maxSize.x), floor(pixel.g * 10) )

