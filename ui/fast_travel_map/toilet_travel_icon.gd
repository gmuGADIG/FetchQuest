extends BaseButton
class_name ToiletTravelIcon

#Stolen from transition Trigger
## Name of the scene to transition to, without the file path or extension.[br]
## e.g. to load [code]res://world/overworld.tscn[/code], just enter [code]overworld[/code][br][br]
## Note that the scene must be present in the worlds or test_scenes folder 
## (but it can be several folders deep within one of those).
## Avoid giving two scenes the same name or this will behave unpredictably.
@export var scene_name: String
@export var entry_point: String
var node_name: String

func _ready() -> void:
	self.visible = FastTravelPoints.point_unlocked(TravelPoint.new(scene_name, entry_point)) #see if its a point that has been visited before
	# do a ton of asserts, to give a pretty little error message in case:
	# file is a uid, path, has an extension, is empty, or couldn't be found
	assert(not scene_name.begins_with("uid"), "Transition trigger at %s uses a UID, instead of a scene name." % self.get_path())
	assert(not scene_name.is_absolute_path(), "Transition trigger at %s uses an absolute path as a scene name, instead of just the file name." % self.get_path())
	assert(scene_name.get_extension() == "", "Transition trigger at %s uses a scene name with a file extension, which should be removed." % self.get_path())
	assert(scene_name != "", "Transition trigger at %s has an empty scene name." % self.get_path())
	assert(SceneManager.scene_exists(scene_name), "Transition trigger at %s could not resolve scene name: '%s'" % [self.get_path(), scene_name])

	pressed.connect(_on_pressed)
#END of Stolen code

func _on_pressed() -> void:
	get_tree().paused = false
	EntryPoints.current_entry_point = entry_point
	SceneTransition.change_scene(SceneManager.get_packed_scene(scene_name))
