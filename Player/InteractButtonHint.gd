extends Sprite2D
@onready var keyboard_image = preload("res://Player/Placeholder_Interact_Button_Keyboard.png")
@onready var controller_image = preload("res://Player/Placeholder_Interact_Button_Controller.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	visible = get_parent().canInteract && not get_parent().inDialogue
	if ControllerManager.isControllerMode():
		texture = controller_image
	else:
		texture = keyboard_image
