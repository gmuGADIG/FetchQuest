class_name EntryPoints extends Node2D
#Written by Samuel Parker (github: samrparker, discord: @samrparker12), contact me if there are any issues!

## When loading a new scene, the player is placed at the entry point with this name.
## This must be the name of a child of this node.
static var current_entry_point: String = ""

static func set_entry_point(entry_point_name: String) -> void:
	current_entry_point = entry_point_name

# On ready, sets the players position to the current entry point
func _ready() -> void:
	var entry_node: Node2D = get_node(current_entry_point)
	
	if current_entry_point == "": printerr("No entry point set! Make sure to set `EntryPoints.current_entry_point` whenever a world scene is loaded.")
	elif entry_node == null: printerr("No entry point of name '%s' was found!" % current_entry_point)
	
	Player.instance.position = entry_node.position
	MainCam.instance.reset_smoothing.call_deferred() # this makes the camera snap to the new position
	
	# reset the entry point. this makes sure it's being set each time the scene changes
	current_entry_point = ""
