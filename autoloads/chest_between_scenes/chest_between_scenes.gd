extends Node

@export var opened_chest : Array[NodePath]
@onready var num_open_chest : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_to_opened_chest(new_chest: NodePath) -> void:
	opened_chest.append(new_chest)
	print("Chest been added " + str(new_chest))
	
func check_if_opened(chest_to_check: NodePath) -> bool:
	
	return false
