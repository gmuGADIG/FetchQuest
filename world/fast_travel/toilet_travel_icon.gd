extends Area2D

#Stolen from transition Trigger
## Name of the scene to transition to, without the file path or extension.[br]
## e.g. to load [code]res://world/overworld.tscn[/code], just enter [code]overworld[/code][br][br]
## Note that the scene must be present in the worlds or test_scenes folder 
## (but it can be several folders deep within one of those).
## Avoid giving two scenes the same name or this will behave unpredictably.
@export var scene_name: String
var node_name: String

func _ready() -> void:
	node_name = scene_name_to_node_name(scene_name)
	print("My node name is " + node_name)
	self.visible = FastTravelPoints.point_unlocked(node_name) #see if its a point that has been visited before
	# do a ton of asserts, to give a pretty little error message in case:
	# file is a uid, path, has an extension, is empty, or couldn't be found
	assert(not scene_name.begins_with("uid"), "Transition trigger at %s uses a UID, instead of a scene name." % self.get_path())
	assert(not scene_name.is_absolute_path(), "Transition trigger at %s uses an absolute path as a scene name, instead of just the file name." % self.get_path())
	assert(scene_name.get_extension() == "", "Transition trigger at %s uses a scene name with a file extension, which should be removed." % self.get_path())
	assert(scene_name != "", "Transition trigger at %s has an empty scene name." % self.get_path())
	assert(SceneManager.scene_exists(scene_name), "Transition trigger at %s could not resolve scene name: '%s'" % [self.get_path(), scene_name])
#END of Stolen code

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("attack"):
		print("clicked! loading " + scene_name)
		get_tree().paused = false;
		SceneTransition.change_scene(SceneManager.get_packed_scene(scene_name))
	
#toilets save root name, scenes are loaded by scene name. This changes a scene name to its root name
func scene_name_to_node_name(sn: String) -> String:
	sn = sn.capitalize()
	sn = sn.replace(' ', '')
	return sn
