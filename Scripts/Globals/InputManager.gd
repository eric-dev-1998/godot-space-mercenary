extends Node

class_name InputManager

# Button state properties:
static var isPrimaryPressed: bool = false
static var isSecondaryPressed: bool = false;
static var isPausePressed: bool = false;
static var isUpPressed: bool = false;
static var isDownPressed: bool = false;
static var isLeftPressed: bool = false;
static var isRightPressed: bool = false;

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			# A key was pressed.
			match(event.keycode):
				KEY_X: isPrimaryPressed = true
				KEY_C: isSecondaryPressed = true
				KEY_ENTER: isPausePressed = true
				KEY_UP: isUpPressed = true
				KEY_DOWN: isDownPressed = true
				KEY_LEFT: isLeftPressed = true
				KEY_RIGHT: isRightPressed = true
			pass
		else:
			# key was released.
			match(event.keycode):
				KEY_X: isPrimaryPressed = false
				KEY_C: isSecondaryPressed = false
				KEY_ENTER: isPausePressed = false
				KEY_UP: isUpPressed = false
				KEY_DOWN: isDownPressed = false
				KEY_LEFT: isLeftPressed = false
				KEY_RIGHT: isRightPressed = false
			pass
