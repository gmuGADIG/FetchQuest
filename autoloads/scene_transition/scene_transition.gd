extends CanvasLayer

# NOTE: The SceneTransition is on its own CanvasLayer. This layer number may
# need to be synchronized with other CanvasLayers throughout the project.

# Provides the function change_scene(), which is essentially a substitute
# for change_scene_to_packed.
#
# We can swap out the animation as necessary as the project evolves.

# Track the scene we will change to. We can only call change_scene
# when this value is null, i.e. when the animation is not already in progress.
var target_scene: PackedScene = null

# By making the animation data exactly 1 second long, we can easily set the
# length of the animation through the animation player speed value.
#
# NOTE: This length value is only read once, in _ready(). It should only be
# used to set a static length for the animation.
@export var anim_length: float = 0.3

func _ready() -> void:
	$AnimationPlayer.speed_scale = 1.0 / anim_length

func change_scene(scene: PackedScene) -> void:
	# Don't accept a null scene as an argument.
	if scene == null:
		return
	
	# Don't interrupt an animation in progress.
	if target_scene != null:
		return
		
	target_scene = scene
	
	# We've leaving the current scene. This animation MUST have a keyframe that
	# will trigger _anim_scene_left().
	$AnimationPlayer.play("LeaveScene")

# Call by the animation player, SceneLeft, when we're ready to change scenes.
func _anim_scene_left() -> void:
	assert(target_scene != null)
	
	get_tree().change_scene_to_packed(target_scene)
	
	$AnimationPlayer.play("EnterScene")
	
	# After we've changed scene, change the scene back to 'null' so that we
	# can transition the scene again.
	target_scene = null
