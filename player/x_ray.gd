class_name XRay extends Node
## Makes a sprite partially visible even when behind something

@export_range(0, 1) var x_ray_opacity := 0.2

func _ready() -> void:
	var dup: Node2D = get_parent().duplicate()

	dup.get_node(NodePath(name)).free()
	dup.visible = true
	dup.set_script(null)
	dup.modulate.a *= x_ray_opacity
	dup.z_index = 10
	dup.transform = Transform2D()

	get_parent().add_child.call_deferred(dup)
	
	var anim := get_parent() as AnimatedSprite2D
	if anim:
		anim.animation_changed.connect(func() -> void:
			(dup as AnimatedSprite2D).play(anim.animation)
		)
