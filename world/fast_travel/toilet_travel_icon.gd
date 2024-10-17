extends Area2D

#Stolen from transition Trigger
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#END of Stolen code

func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("attack"):
		print("clicked! loading " + scene_name)
		get_tree().paused = false;
		SceneTransition.change_scene(load(_scene_dict[scene_name]))
	pass # Replace with function body.
	
