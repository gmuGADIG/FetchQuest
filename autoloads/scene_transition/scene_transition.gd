extends CanvasLayer

# NOTE: The SceneTransition is on its own CanvasLayer. This layer number may
# need to be synchronized with other CanvasLayers throughout the project.

# Provides the function change_scene(), which is essentially a substitute
# for change_scene_to_packed.
#
# We can swap out the animation as necessary as the project evolves.

# During a transition, this will be the path of the scene being loaded.
# Otherwise, it will be ""
var target_scene_path: String = ""

# By making the animation data exactly 1 second long, we can easily set the
# length of the animation through the animation player speed value.
#
# NOTE: This length value is only read once, in _ready(). It should only be
# used to set a static length for the animation.
@export var anim_length: float = 0.3

func _ready() -> void:
	$AnimationPlayer.speed_scale = 1.0 / anim_length

func _is_transition_in_progress() -> bool:
	return target_scene_path != ""

func change_scene_to_path(scene_path: String, boss_transition: bool = false) -> void:
	assert(scene_path != "")
	if _is_transition_in_progress(): return # Don't interrupt an animation in progress.

	target_scene_path = scene_path
	#ResourceLoader.load_threaded_request(target_scene_path)
	
	# We've leaving the current scene. This animation MUST have a keyframe that
	# will trigger _anim_scene_left().
	$AnimationPlayer.play("BossLeaveScene" if boss_transition else "LeaveScene")

func change_scene(scene_name: String, boss_transition: bool = false) -> void:
	change_scene_to_path(SceneManager.get_scene_path(scene_name), boss_transition)

# Call by the animation player, SceneLeft, when we're ready to change scenes.
func _anim_scene_left() -> void:
	assert(target_scene_path != "")
	
	var scene := load(target_scene_path)
	#var scene := ResourceLoader.load_threaded_get(target_scene_path)
	get_tree().change_scene_to_packed(scene)
	
	$AnimationPlayer.play("EnterScene")
	
	# After we've changed scene, change the scene back to empty so that we
	# can transition the scene again.
	target_scene_path = ""
