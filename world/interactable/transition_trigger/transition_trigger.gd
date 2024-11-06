class_name TransitionScene extends Area2D

## Name of the scene to transition to, without the file path or extension.[br]
## e.g. to load [code]res://world/overworld.tscn[/code], just enter [code]overworld[/code][br][br]
## Note that the scene must be present in the worlds or test_scenes folder 
## (but it can be several folders deep within one of those).
## Avoid giving two scenes the same name or this will behave unpredictably.
@export var scene_name: String

## The entry point the player should entry the new scene from. [br]
## The scene's `EntryPoint` node should have a child of this name.
@export var entry_point: String

static var _scene_dict: Dictionary = {}

static func _static_init() -> void:
	update_scene_dict("res://test_scenes/")
	update_scene_dict("res://world/")

func _ready() -> void:
	# do a ton of asserts, to give a pretty little error message in case:
	# file is a uid, path, has an extension, is empty, or couldn't be found
	assert(not scene_name.begins_with("uid"), "Transition trigger at %s uses a UID, instead of a scene name." % self.get_path())
	assert(not scene_name.is_absolute_path(), "Transition trigger at %s uses an absolute path as a scene name, instead of just the file name." % self.get_path())
	assert(scene_name.get_extension() == "", "Transition trigger at %s uses a scene name with a file extension, which should be removed." % self.get_path())
	assert(scene_name != "", "Transition trigger at %s has an empty scene name." % self.get_path())
	assert(SceneManager.scene_exists(scene_name), "Transition trigger at %s could not resolve scene name: '%s'" % [self.get_path(), scene_name])

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		EntryPoints.set_entry_point(entry_point)
		SceneTransition.change_scene(SceneManager.get_packed_scene(scene_name))
