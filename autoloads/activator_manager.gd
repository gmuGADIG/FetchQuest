extends Node

func _on_switch_activated(activatable: Node) -> void:
	activatable.activate()

func _on_scene_ready() -> void:
	for activator in get_tree().get_nodes_in_group(ActivatorPlugin.ACTIVATOR_GROUP):
		for np: NodePath in activator.get_meta(ActivatorPlugin.META_NAME, []):
			var activatable := activator.get_node(np)

			if activatable.has_method("activate") and activator.has_signal("switch_activated"):
				activator.switch_activated.connect(activatable.activate)
			if activatable.has_method("deactivate") and activator.has_signal("switch_deactivated"):
				activator.switch_deactivated.connect(activatable.deactivate)



func _on_node_added(node: Node) -> void:
	if get_tree().current_scene == node:
		print("scene changed!")
		node.ready.connect(_on_scene_ready)

# just fast enough: this should call before the first scene's _ready
func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)
