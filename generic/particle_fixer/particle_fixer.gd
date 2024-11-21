extends Node

@export var enable_on_ready := true
@export var free_when_finished := true

func _ready() -> void:
	var parent: CPUParticles2D = get_parent()
	assert(parent != null)

	if enable_on_ready:
		parent.emitting = true

	if free_when_finished:
		parent.finished.connect(parent.queue_free)

