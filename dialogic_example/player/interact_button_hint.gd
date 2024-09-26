extends Sprite2D
@onready var keyboard_image: Texture2D = preload("uid://cc75mo1x1ung5")
@onready var controller_image: Texture2D = preload("uid://bi1qauk62f03d")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	visible = get_parent().can_interact && not get_parent().in_dialogue
	if ControllerManager.is_controller:
		texture = controller_image
	else:
		texture = keyboard_image
