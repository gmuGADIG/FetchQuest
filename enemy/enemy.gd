# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

@export var max_health: int = 3
@export var damage : int = 1
@export var knockback_force : int = 10
@onready var health := max_health
# the max distance the entity will move from its starting position, aka that radius of the circle that the entity is allowed to move in
@export var roaming_radius : float = 100

@export_range(0, 1) var pickup_drop_chance: float = 0.5 ## Chance of dropping a pick-up (hp, bomb, or stamina) on death

var enemy_state := EnemyState.ROAMING

@onready var original_position : Vector2 = position
@onready var target_position: Vector2 = _get_roaming_target()
var roaming_time : float = 0.0

enum EnemyState {
	ROAMING,
	AGRESSIVE,
	STUNNED
}

func _process(delta: float) -> void:
	match enemy_state:
		EnemyState.ROAMING:
			_process_roaming(delta)
		EnemyState.AGRESSIVE:
			_process_agressive(delta)
		EnemyState.STUNNED:
			_process_stunned(delta)
	move_and_slide()
	
		
## Damages the enemy, killing it if its health drops below zero.
## This should be called by the player's attacks when they hit an enemy.
func hurt(damage_event: DamageEvent) -> void:
	if health <= 0: return # don't die twice

	health -= damage_event.damage
	#position += damage_event.knockback
	
	print("Enemy.gd: Health of '%s' was lowered to %s/%s" % [get_path(), health, max_health])

	if health <= 0:
		on_death()
		queue_free()

## Function to call upon death of enemy
func on_death() -> void:
	# if the chance fails, bail out of the function and do nothing
	if (randf() > pickup_drop_chance): return
	
	# add bombs, health, and stamina to the list of possible drops, after checking if they're eligible
	var eligible_pickup_paths: Array[String]
	if (Player.instance.health < Player.instance.max_health):
		eligible_pickup_paths.append("res://world/environment/pickups/pickup_health.tscn") # health
	if (PlayerInventory.bombs < PlayerInventory.max_bombs):
		eligible_pickup_paths.append("res://world/environment/pickups/pickup_bomb.tscn") # bomb
	eligible_pickup_paths.append("res://world/environment/pickups/pickup_stamina.tscn") # stamina (unconditional)
	
	# If, somehow, there are no eligible items, then sound the alarms and bail 
	if (eligible_pickup_paths.is_empty()):
		push_error("enemy.gd: No valid pickup drops were possible!")
		return
	
	# pick an eligible item and get the scene path
	var chosen: String = eligible_pickup_paths.pick_random()
	var dropped_item: Node2D = load(chosen).instantiate()
	dropped_item.position = position
	add_sibling.call_deferred(dropped_item)
	print("Item '", dropped_item.name, "' was dropped by ", get_path())
	
func _process_roaming(delta: float) -> void:
	var target_reached := position.distance_to(target_position) <= 5.0
	if target_reached: # target reached; set new target and wait
		target_position = _get_roaming_target()
		roaming_time = randf_range(.5, 1)
		velocity = Vector2.ZERO
	elif roaming_time > 0: # waiting; subtract from timer and do nothing
		roaming_time -= delta
	else: # still approaching target
		approach(target_position)

## gets a new random position to roam towards
func _get_roaming_target() -> Vector2:
	var radian: float = randf_range(0, 2*PI)
	var distance: float =  randf_range(0, roaming_radius)
	return original_position + Vector2(distance * cos(radian), distance * sin(radian))

func approach(target: Vector2) -> void:
	velocity = position.direction_to(target) * 200 # temporary movement code. TODO: replace with proper navigation
	
func _process_agressive(_delta: float) -> void:
	pass
	
func _process_stunned(_delta: float) -> void:
	pass
	

func _on_hitting_area_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player != null:
		var knockback := global_position.direction_to(player.global_position) * knockback_force
		player.hurt(DamageEvent.new(damage, knockback))
