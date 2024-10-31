class_name Amalgamation extends Node2D
#NOTE borrowing some of functions from enemy.gd for familiarity

@export_group("Stats")
## The health that the boss starts with
@export var max_health:int = 100
## The current health of the boss
@onready var health := max_health :
	# Emit a signal when the health is changed
	set(value):
		health = value
		health_changed.emit()
## The signal emitted when the health is changed
signal health_changed

## The damage the amalgamation does when the player touches the boss
@export var contact_damage:int = 1

## The state machine
@onready var state_machine:AmalgamationStateMachine = $StateMachine
## The animation player 
@onready var animation_player:AnimationPlayer = $AnimationPlayer

@export_group("Attack Selection")
## The node that contains the sucking logic
@export var sucking_state:AmalgamationSuckingState
## The node that contains the pillars logic
@export var pillar_state:AmalgamationPillarsState
## The node that contains the spitting logic
@export var spit_state:AmalgamationSpittingState
## The weight of the sucking state being selected
@export var sucking_weight:float = 1
## The weight of the pillar state being selected
@export var pillar_weight:float = 1
## The weight of the spitting state being selected
@export var spit_weight:float = 1

@export_group("Pillar Attack")
## How many pillars to spawn
@export var pillar_count:int = 15
## The center of the room (for pillar spawning)
@export var room_center:Node2D
## The size of the room (for pillar spawning)
@export var room_size:Vector2

@export_group("Spitting Attack")
## The enemies that can be spat out by the amalgamation
@export var spitting_possible_enemies:Array[PackedScene]
## The amount of times that the amalgamation will spit before ending the attack
@export var spitting_number:int = 3
## The distance from the mouth that enemies and the player will be spat out
@export var spitting_distance:float = 400

@export_group("Sucking Attack")
## The speed in pixels per second that the amalgamation everything in at
@export var sucking_speed:float = 200

@export_group("State Durations")
## The duration of the pillar attack state
@export var pillar_state_duration:float = 2.0
## The duration of the spitting attack state
@export var spitting_state_duration:float = 2.0
## The duration of the sucking attack state
@export var sucking_state_duration:float = 2.0
## The duration of the chewing state
@export var idle_state_duration:float = 2.0
## The duration of the chewing state
@export var chewing_state_duration:float = 2.0
## The duration of the vulnerable state
@export var vulnerable_state_duration:float = 2.0

func hurt(damage_event: DamageEvent) -> void:
	# Dont die twice
	if health <= 0:
		return
	
	# Only take damage when vulnerable
	if state_machine.current_state is not AmalgamationVulnerableState:
		return
	
	# Take damage
	health -= damage_event.damage
	health = clampi(health, 0, max_health)
	
	print("thee_amalgamation.gd: Id rate my health %s/%s" % [health, max_health])
	
	# Hit animation
	animation_player.play("Hurt")
	await animation_player.animation_finished
	
	# Switch back to vulnerable unless in different state
	if state_machine.current_state is AmalgamationVulnerableState:
		animation_player.play("Vulnerable")
	
	# Die if dead X_X
	if health <= 0:
		die()


func _on_hitbox_area_body_entered(body: Node2D) -> void:
	# Hurt the player
	if body is Player:
		body.hurt(DamageEvent.new(contact_damage))

func die() -> void:
	print("thee_amalgamation.gd: X_X")
