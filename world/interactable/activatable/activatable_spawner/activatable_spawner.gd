extends Node2D

var children: Array[Node]

func _enter_tree() -> void:
	for child in get_children():
		children.push_back(child)
		remove_child(child)

func activate() -> void:
	for child in children:
		add_child(child)
	
	# make sure to avoid double activation
	children = []
