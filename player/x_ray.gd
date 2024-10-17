extends Sprite2D
## Makes a sprite partially visible even when behind something

@export_range(0, 1) var x_ray_opacity := 0.1

func _ready() -> void:
	var x_ray_sprite: Sprite2D = self.duplicate()
	x_ray_sprite.set_script(null)
	x_ray_sprite.modulate.a *= x_ray_opacity
	x_ray_sprite.z_index = 10
	add_sibling.call_deferred(x_ray_sprite)
