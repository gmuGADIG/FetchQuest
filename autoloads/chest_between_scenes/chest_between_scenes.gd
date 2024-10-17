extends Node

@export var opened_chest : Array[NodePath]
## Will track if chest has already been opened

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
#Called by chest, adds chest's path to list
func add_to_opened_chest(new_chest: NodePath) -> void:
	opened_chest.append(new_chest)
	print("Chest been added " + str(new_chest))
	
#When chest is loaded it will call this function to see if it was opened before
func check_if_opened(chest_to_check: NodePath) -> bool:
	for saved_chest in opened_chest:      #loop through list of opened chest
		if chest_to_check == saved_chest:
			print("We have opened this test before")
			return true  # it has been opened
	print("We have not opened " + str(chest_to_check))
	return false   #it hasn't been opened
