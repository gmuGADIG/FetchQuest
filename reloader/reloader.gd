extends Node

var saves: Array[ReloadableNode] = []

## Enemies will be loaded when this far outside the screen. 0 means they will spawn exactly at the border
const SPAWN_MARGIN := 100.0

## Enemies will be unloaded when this far outside the screen. 0 means they will despawn exactly at the border
const DESPAWN_MARGIN := 200.0

func _ready() -> void:
	print("reloader starting")
	for reloadable in get_tree().get_nodes_in_group("reloads"):
		assert(reloadable is Reloadable, "Node '%s' should not be in the 'reloads' group!" % reloadable.get_path())
		
		var node = reloadable.get_parent() # the Reloadable node is added as a component to the node we want to save
		print("saving node '%s'" % node.get_path())
		
		# take the node out of the tree, and add it to our own list as a ReloadableNode
		node.get_parent().remove_child(node)
		var rel = ReloadableNode.new()
		rel.saved_node = node
		rel.visible_rect = reloadable.rect
		saves.append(rel)
 
func _process(delta: float) -> void:
	for reloadable_node in saves:
		if reloadable_node.instanced_node != null:
			# node is in tree; handle despawning
			if not _is_on_screen(reloadable_node.get_global_visible_rect(), DESPAWN_MARGIN):
				print("Freeing node '%s'" % reloadable_node.instanced_node.name)
				reloadable_node.instanced_node.queue_free()
		else:
			# node is unloaded; handle spawning
			if _is_on_screen(reloadable_node.get_global_visible_rect(), SPAWN_MARGIN):
				print("Loading node '%s'" % reloadable_node.saved_node.name)
				get_tree().current_scene.add_child(reloadable_node.instantiate())
	
func _is_on_screen(rect: Rect2, margin: float = 0) -> bool:
	var cam = get_viewport().get_camera_2d()
	var center = cam.get_screen_center_position()
	var size = get_viewport().get_visible_rect().size
	var screen_rect = Rect2(center - size / 2.0, size)

	return screen_rect.grow(margin).intersects(rect)

class ReloadableNode:
	var visible_rect: Rect2 ## local visibility rect, as defined by the Reloadable node
	var saved_node: Node2D ## The node saved outside the scene tree
	var instanced_node: Node2D ## Nullable reference to the node inside the tree

	func instantiate():
		assert(instanced_node == null, "Try to instantiate a ReloadableNode when an instance already exists!")
		instanced_node = saved_node.duplicate()
		return instanced_node
	
	func get_global_visible_rect():
		var rect = visible_rect
		if instanced_node != null:
			rect.position += instanced_node.global_position
		else:
			rect.position += saved_node.global_position
		return rect
