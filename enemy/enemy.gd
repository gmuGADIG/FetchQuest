# NOTE: This script applies to all enemies.
# To create a new enemy, create an inherited scene from the base enemy, then 
# replace the existing script with a new script extending `Enemy`.

class_name Enemy extends CharacterBody2D

@export var max_health: int = 3
@onready var health := max_health


#The desired range the enemy wants to navigate to
@export var agressive_target_distance_min: int = 1
@export var agressive_target_distance_max: int = 300

var enemy_state : EnemyState = EnemyState.ROAMING
var navigation_target: Vector2 = self.position

enum EnemyState {
	ROAMING,
	AGRESSIVE,
	STUNNED
}

func _ready() -> void:
	enemy_state = EnemyState.AGRESSIVE

func _process(delta: float) -> void:
	match enemy_state:
		EnemyState.ROAMING:
			_process_roaming(delta)
		EnemyState.AGRESSIVE:
			_process_agressive(delta)
		EnemyState.STUNNED:
			_process_stunned(delta)
	
		
## Damages the enemy, killing it if its health drops below zero.
## This should be called by the player's attacks when they hit an enemy.
func hurt(damage_event: DamageEvent) -> void:
	if health <= 0: return # don't die twice

	health -= damage_event.damage
	#position += damage_event.knockback
	
	print("Enemy.gd: Health of '%s' was lowered to %s/%s" % [get_path(), health, max_health])

	if health <= 0:
		queue_free()
		
func _process_roaming(delta: float) -> void:
	pass
	
func _process_agressive(delta: float) -> void:
	#Note that these variables are the square distance
	var enemy_distance: float = self.position.distance_to(Player.instance.position)
	var navigation_target_distance: float = navigation_target.distance_to(Player.instance.position)
	var player_location: Vector2 = Player.instance.position
	var target_distance: float = agressive_target_distance_min+(agressive_target_distance_max-agressive_target_distance_min)/2
	var target_direction: Vector2
	
	var target : Vector2
	#When the enemy is inside of the valid target region
	
	
	if (enemy_distance > agressive_target_distance_min) && (enemy_distance < agressive_target_distance_max):
		if(self.position.distance_squared_to(navigation_target)>10):
			pass
		const angle_variance := deg_to_rad(10)
		target_direction = player_location.direction_to(self.position).rotated(randf_range(-1, 1) * angle_variance)
		target = player_location+target_direction*target_distance;
	else:
		target_direction = player_location.direction_to(self.position)
		target = player_location+target_direction*target_distance;
	approach(target)
	self.position = target
		
func _process_stunned(delta: float) -> void:
	pass
	
	
func approach(target: Vector2) -> void:#THIS IS DUMMY CODE, USE THE METHOD FROM THE NAVIGATION BRANCH
	navigation_target = target
	pass
	
