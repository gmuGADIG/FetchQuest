extends Sprite2D
@onready var keyboard_image = preload("uid://cc75mo1x1ung5")
@onready var controller_image = preload("uid://bi1qauk62f03d")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	visible = get_parent().canInteract && not get_parent().inDialogue
	if ControllerManager.isControllerMode():
		texture = controller_image
	else:
		texture = keyboard_image
