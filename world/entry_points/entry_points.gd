class_name EntryPoints extends Node2D
#Written by Samuel Parker (github: samrparker, discord: @samrparker12), contact me if there are any issues!

static var instance: EntryPoints

## When loading a new scene, the player is placed at the entry point with this name.
## This must be the name of a child of this node.
static var current_entry_point: String = ""
static var last_entry_point: String = ""

static func set_entry_point(entry_point_name: String) -> void:
	current_entry_point = entry_point_name

func _init() -> void:
	instance = self

# On ready, sets the players position to the current entry point
func _ready() -> void:
	assert(get_child_count() != 0, "Scene has no entry points! Add a child to the EryPoints node, with a name that will be referred to by anything entering this scene.")
	
	var entry_node: Node2D = get_node_or_null(current_entry_point)
	if current_entry_point == "":
		if get_child_count() == 0: 
			printerr("No entry point in scene")
			return
		print("Entered scene without transition, using first entry point")
		entry_node = get_child(0)
	if entry_node == null: 
		printerr("No entry point of name '%s' was found!" % current_entry_point)
	else:
		Player.instance.global_position = entry_node.global_position
	
	# reset the entry point. this makes sure it's being set each time the scene changes
	last_entry_point = current_entry_point
	current_entry_point = ""

	MainCam.instance.global_position = Player.instance.global_position
	MainCam.instance.reset_smoothing.call_deferred()
