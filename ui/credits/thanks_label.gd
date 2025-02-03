extends RichTextLabel

var flag := true
func _process(delta: float) -> void:
	if global_position.y <= 280 and flag:
		flag = false
		
		var gp := global_position
		var current_scene := get_tree().current_scene
		get_parent().remove_child(self)
		
		position = gp - current_scene.global_position
		current_scene.add_child(self)
