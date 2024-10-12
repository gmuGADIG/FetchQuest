class_name Reloader extends Node

var saves: Array[ReloadableNode] = []

## Enemies will be loaded when this far outside the screen.
## 0 means they will spawn exactly at the border.
@export var spawn_margin := 100.0

## Enemies will be unloaded when this far outside the screen.
## 0 means they will despawn exactly at the border.
## This should be larger than [member spawn_margin]
@export var despawn_margin := 200.0

func _ready() -> void:
	#print("reloader: starting")
	for reloadable in get_tree().get_nodes_in_group("Reloads"):
		assert(reloadable is Reloadable, "Reloadable node '%s' should not be in the 'Reloads' group!" % reloadable.get_path())
		
		# note: the Reloadable node is added as a component to the node we want to save, so we get the parent
		var node := reloadable.get_parent()
		#print("reloader: saving node '%s'" % node.get_path())
		
		# take the node out of the tree, and add it to our own list as a ReloadableNode
		node.get_parent().remove_child.call_deferred(node)
		var rel := ReloadableNode.new()
		rel.saved_node = node
		rel.visible_rect = reloadable.rect
		saves.append(rel)
 
func _process(delta: float) -> void:
	for reloadable_node in saves:
		if not reloadable_node.loaded:
			# node isn't loaded; handle spawning
			if _is_on_screen(reloadable_node.get_global_visible_rect(), spawn_margin):
				print("Loading node '%s'" % reloadable_node.saved_node.name)
				get_tree().current_scene.add_child(reloadable_node.instantiate())
				reloadable_node.loaded = true
		else:
			# node has been loaded; handle despawning
			# note that the node instance may still be null (if e.g. an enemy died)
			if not _is_on_screen(reloadable_node.get_global_visible_rect(), despawn_margin):
				print("Freeing node '%s'" % reloadable_node.saved_node.name)
				if reloadable_node.instanced_node != null:
					reloadable_node.instanced_node.queue_free()
				reloadable_node.loaded = false
	
func _is_on_screen(rect: Rect2, margin: float = 0) -> bool:
	var cam := get_viewport().get_camera_2d()
	var center := cam.get_screen_center_position()
	var size := get_viewport().get_visible_rect().size / cam.zoom
	var screen_rect := Rect2(center - size / 2.0, size)

	return screen_rect.grow(margin).intersects(rect)

class ReloadableNode:
	var visible_rect: Rect2 ## local visibility rect, as defined by the Reloadable node
	var saved_node: Node2D ## The node saved outside the scene tree
	var instanced_node: Node2D ## Nullable reference to the node inside the tree
	var loaded := false

	func instantiate() -> Node2D:
		assert(instanced_node == null, "Try to instantiate a ReloadableNode when an instance already exists!")
		instanced_node = saved_node.duplicate()
		return instanced_node
	
	func get_global_visible_rect() -> Rect2:
		var rect := visible_rect
		if instanced_node != null:
			rect.position += instanced_node.global_position
		else:
			rect.position += saved_node.global_position
		return rect
