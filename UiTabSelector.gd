extends TabBar

var prevIdx:int
var box
var unitui
var instance

func selectedUnit():
	print("selected")

func _preloadUnitTab():
	#box = HBoxContainer.new()
	#self.add_child(box)
	unitui = preload("res://UnitUi.tscn")
	instance = unitui.instantiate()
	self.get_parent().get_child(1).add_child(instance)
	instance.giveMeSignal().connect(self.selectedUnit)
	#self.add_child(unitui)
	#instance.hide()
	
	#box.hide()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	tab_changed.connect(self._tabChangedLoadUI)
	prevIdx = 0
	_preloadUnitTab()
	_tabChangedLoadUI(0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func loadUnitList():
	#box.show()
	instance.show()

func _tabChangedLoadUI(idx:int):
	print("tab changed to: ", idx)
	if (idx == 0):
		loadUnitList()
