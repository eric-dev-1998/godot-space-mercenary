extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var label: Label = get_node("Label_data")
	
	var data = ("Primary: " + str(InputManager.isPrimaryPressed)
	+ "\nSecondary: " + str(InputManager.isSecondaryPressed)
	+ "\nPause: " + str(InputManager.isPausePressed)
	+ "\nUp: " + str(InputManager.isUpPressed)
	+ "\nDown: " + str(InputManager.isDownPressed)
	+ "\nLeft: " + str(InputManager.isLeftPressed)
	+ "\nRight: " + str(InputManager.isRightPressed))
	
	label.text = data;
	pass
