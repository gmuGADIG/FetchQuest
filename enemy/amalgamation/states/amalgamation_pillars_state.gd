class_name AmalgamationPillarsState extends AmalgamationState

@export var pillar_scene:PackedScene
@export var pillar_count:int = 15

var pillars_spawned: Array[Node2D] = []
func enter() -> void:
	summon_pillars()
	await get_tree().create_timer(8).timeout
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, "Idle")


func exit() -> void:
	for pillar in pillars_spawned:
		if is_instance_valid(pillar):
			pillar.queue_free()

func spawn_pillar(location:Vector2) -> Node2D:
	var pillar:Node2D = pillar_scene.instantiate()
	pillar.global_position = location
	state_machine.get_parent().add_sibling(pillar)
	return pillar

func summon_pillars() -> void:
	var screen_width:float = get_viewport().size.x
	var screen_height:float = get_viewport().size.y
	for i in range(pillar_count - 1):
		var random_position:Vector2 = Player.instance.global_position + Vector2(randf_range(-screen_width / 2, screen_width / 2),randf_range(-screen_height / 2,screen_height / 2));
		pillars_spawned.append(spawn_pillar(random_position))
	pillars_spawned.append(spawn_pillar(Player.instance.global_position))
