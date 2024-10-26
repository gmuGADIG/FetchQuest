@tool
class_name ActivatorPlugin extends EditorPlugin

const ACTIVATOR_GROUP = "Activator"
const ACTIVATABLE_GROUP = "Activatable"
const META_NAME = "Activatables"

const ACTIVATE_METHOD = "activate"
const DEACTIVATE_METHOD = "deactivate"

var activator: Node2D = null

var gui_scene = preload("toolbar.tscn")
@onready var gui: ActivatorPluginToolbar 

var tool_active: bool:
	set(v):
		gui.button.button_pressed = v
	get:
		return gui.button.button_pressed

func _toggle_connection_actual(node: Node) -> void:
	# it's supposed to be Array[NodePath] but godot sucks
	var list: Array = activator.get_meta(META_NAME, [])
	var idx = list.find(activator.get_path_to(node))

	if idx == -1:
		list.push_back(activator.get_path_to(node))
	else:
		list.remove_at(idx)
	
	activator.set_meta(META_NAME, list)

	update_overlays()


func _toggle_connection(node: Node) -> void:
	assert(node.is_in_group(ACTIVATABLE_GROUP))

	var list: Array = activator.get_meta(META_NAME, [])
	var idx = list.find(activator.get_path_to(node))

	var msg := ""

	if idx == -1:
		msg = "Connect %s to %s" % [activator.name, node.name]
	else:
		msg = "Disconnect %s to %s" % [activator.name, node.name]

	var undo_redo := get_undo_redo()

	undo_redo.create_action(msg, 0, activator)
	undo_redo.add_do_method(self, "_toggle_connection_actual", node)
	undo_redo.add_undo_method(self, "_toggle_connection_actual", node)
	undo_redo.commit_action()

func _forward_canvas_draw_over_viewport(overlay: Control) -> void:
	if not tool_active: return

	for np in activator.get_meta(META_NAME, []):
		var node: Node2D = activator.get_node(np)
		var t := EditorInterface.get_editor_viewport_2d().global_canvas_transform
		var p1 := t * activator.global_position
		var p2 := t * node.global_position
		overlay.draw_line(p1, p2, Color.YELLOW, 5, true)

func _on_selection_changed():
	if activator == null or not EditorInterface.get_edited_scene_root().is_ancestor_of(activator):
		_reset()

	var selection := EditorInterface.get_selection()
	var nodes := selection.get_selected_nodes()

	if tool_active:
		var n := nodes[0]
		if n == activator: return
		if not n.is_in_group(ACTIVATABLE_GROUP): return

		_toggle_connection(n)

		# reset selection
		selection.clear()
		EditorInterface.edit_node(activator)

		return

	activator = null

	var dup := false
	for node in nodes:
		if node.is_in_group(ACTIVATOR_GROUP):
			if dup: # if multiple activators are selected, don't do anything
				activator = null
				break

			activator = node
			dup = true
	
	gui.visible = activator != null

	print("activator: ", null if activator == null else activator.name)

# reset state
func _reset() -> void:
	activator = null
	tool_active = false

func _on_tool_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		EditorInterface.get_selection().clear()
		EditorInterface.edit_node(activator)
	update_overlays()

func _handles(object: Object) -> bool:
	return object is Node2D

func _enter_tree() -> void:
	gui = gui_scene.instantiate()
	gui.visible = false # gui should only be visible if activator is selected
	gui.tool_button_toggled.connect(_on_tool_button_toggled)

	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, gui)
	EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)

func _exit_tree() -> void:
	EditorInterface.get_selection().selection_changed.disconnect(_on_selection_changed)
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, gui)
	gui.queue_free()
