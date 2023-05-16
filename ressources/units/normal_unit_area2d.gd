extends Area2D


func  _input(event: InputEvent):
	if event == InputEventMouse and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print ("unit selected")
