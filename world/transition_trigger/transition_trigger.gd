class_name TransitionScene extends Area2D

## Name of the scene to transition to, without the file path or extension.[br]
## e.g. to load [code]res://world/overworld.tscn[/code], just enter [code]overworld[/code][br][br]
## Note that the scene must be present in the worlds or test_scenes folder (but it can be several folders deep within one of those).
## Avoid giving two scenes the same name or this will behave unpredictably.
@export var scene_name: String

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
	assert(scene_name in _scene_dict, "Transition trigger at %s could not resolve scene name: '%s'" % [self.get_path(), scene_name])

static func update_scene_dict(path: String) -> void:
	print("path = ", path)
	
	var dir := DirAccess.open(path)
	assert(dir != null)
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			if file_name != "addons":
				update_scene_dict(path + "/" + file_name)
		else:
			if file_name.get_extension() == "tscn":
				_scene_dict[file_name.get_basename()] = path + "/" + file_name

		file_name = dir.get_next()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SceneTransition.change_scene(load(_scene_dict[scene_name]))
