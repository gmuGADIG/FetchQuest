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

# idk therell probably be more up here ^^^
# damage maybe?
# maybe references to colliders instead of using $ and %

## The state machine
@onready var state_machine:AmalgamationStateMachine = $StateMachine

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
## How long the pillar will be falling
@export var pillar_fall_time:float = 5

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

@export_group("Vulnerability")
## How long the boss stays vulnerable after it is triggered
@export var vulnerability_duration:float = 5
func hurt(damage_event: DamageEvent) -> void:
	# Dont die twice
	if health <= 0: 
		return 
	# Take damage
	health -= damage_event.damage
	health = clampi(health, 0, max_health)
	
	print("thee_amalgamation.gd: Health was lowered to %s/%s" % [health, max_health])
	
	# Die if dead X_X
	if health <= 0:
		die()


func _on_hurtbox_area_body_entered(body: Node2D) -> void:
	# No contact damage in asleep state
	#NOTE i dont remember why this was in our plans, might just be from our delusions and get removed
	if state_machine.current_state is AmalgamationAsleepState: return
	
	# Hurt the player
	if body is Player:
		body.hurt(DamageEvent.new(1))

func die() -> void:
	print("thee_amalgamation.gd: X_X")
