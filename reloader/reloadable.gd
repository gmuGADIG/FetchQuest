class_name Reloadable extends VisibleOnScreenNotifier2D

func _ready() -> void:
	assert(self.is_in_group("reloads"), "Reloadable at '%s' must be in the 'Reloads' group!" % get_path())
