## Static class for picking scenes from their names.
## 
## The use case for this is for things that move the player 
## between scenes, such as the transition trigger area or
## world map. [br][br]
## 
## Basic usage:
## [codeblock]
## # Assume some scene exists at `res://world/really/long/path/questbrook.tscn`
## 
## func _ready(): 
##   assert(SceneManager.scene_exists("questbrook"))
## 
## func _on_some_signal():
##   SceneTransition.change_scene(SceneManager.get_packed_scene("questbrook"))
## [/codeblock]
## 
## [b][color=yellow]Note:[/color][/b] SceneManager only looks in [code]res://test_scenes/[/code] 
## and [code]res://world/[/code] for scenes.
class_name SceneManager

static var _scene_dict: Dictionary = {}

static func _static_init() -> void:
	_update_scene_dict("res://test_scenes/")
	_update_scene_dict("res://world/")

static func _update_scene_dict(path: String) -> void:	
	var dir := DirAccess.open(path)
	assert(dir != null)
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			if file_name != "addons":
				_update_scene_dict(path + "/" + file_name)
		else:
			file_name = file_name.trim_suffix(".remap") # godotengine/godot#66014
			if file_name.get_extension() == "tscn":
				_scene_dict[file_name.get_basename()] = path + "/" + file_name

		file_name = dir.get_next()

## Returns [code]true[/code] if [param scene_name] is mapped to a scene.
static func scene_exists(scene_name: String) -> bool:
	return scene_name in _scene_dict

## Returns the packed scene who's file name corresponds to [param scene_name].
static func get_packed_scene(scene_name: String) -> PackedScene:
	return load(_scene_dict[scene_name])
