class_name King extends CharacterBody2D

@export_group("Stats")
## Amount of hits the boss can take
@export var max_health:int = 10
## Current health
@onready var health:int = max_health:
	# Emit a signal when the health is changed
	set(value):
		health = value
		health_changed.emit()
## The signal emitted when the health is changed
signal health_changed


@export_group("Movement (Teleporting)")
## The positions that the king can randomly teleport to
@export var movement_points:Array[Node2D]
## The time between randomly teleporting between points
@export var time_between_teleports:float = 3
## Place most recently teleported to 
@onready var previous_teleport_position:Vector2 = global_position

@export_group("Attack Selection")
## The exploding mushrooms attack
@export var mushroom_state:KingMushroomState
## The scepter throw attack
@export var throw_state:KingThrowState
## The dog whistle attack
@export var whistle_state:KingWhistleState
## All of the attack states
@onready var attack_states:Array = [mushroom_state, throw_state, whistle_state]
## Most recently chosen attack state
var previous_attack_state:KingState = null
## The chance of choosing the exploding mushroom attack
@export var mushroom_state_weight:float = 1.0 / 3.0
## The chance of choosing the scepter throw attack
@export var throw_state_weight:float = 1.0 / 3.0
## The chance of choosing the dog whistle attack
@export var whistle_state_weight:float = 1.0 / 3.0
## All of the attack weights
@onready var attack_state_weights:Array = [mushroom_state_weight, throw_state_weight, whistle_state_weight]
## Time spent selecting attacks
@export var time_between_attacks:float = 2

@export_group("Mushroom Cloud")
## The exploding mushroom scene
var mushroom_scene:PackedScene = preload("res://enemy/king_boss/king_exploding_mushroom.tscn")
## How many exploding mushrooms are spawned
@export var mushroom_count:int = 50
## How long the mushrooms stay on screen
@export var mushroom_lifetime:float = 2
## The center of the room (used for spawning mushrooms)
@export var room_center:Node2D
## The size of the room (used for spawning mushrooms) 
@export var room_size:Vector2

@export_group("Dog Whistle")
## Total shockwaves in the attack
@export var total_shockwaves:int = 10
## Time between each shockwave 
@export var time_between_shockwaves:float = 3

@export_group("Scepter Throw")
## How many times the scepter is thrown per attack
@export var total_scepter_throws:int = 2
## The scene that contains the ThrownScepter
var thrown_scepter_scene:PackedScene = preload("res://enemy/king_boss/king_thrown_scepter.tscn")
## The scene that contains the DroppedScepter
var lost_scepter_scene:PackedScene = preload("res://enemy/king_boss/king_dropped_scepter.tscn")
## The scepter that the king dropped
var current_lost_scepter:Node2D = null

@export_group("Vulnerable State")
## How far to move while panicking (in pixels)
@export var panic_distance:float = 200
## How fast the king moves to each panic point (in pixels per second)
@export var panic_speed:float = 200 
## How long the king will panic for (in seconds)
@export var panic_duration:float = 4
## How many panic points to create
@onready var total_panic_points:int = floori(panic_distance / panic_speed * panic_duration)
## The sprite that contains the unhittable aura
@onready var bubble_sprite:Sprite2D = $BubbleSprite


func _ready() -> void:
	# Set up the teleportation timer
	$RandomTeleportTimer.wait_time = time_between_teleports
	$RandomTeleportTimer.start()

func randomly_teleport() -> void:
	# Pick a random position and teleport to it
	while global_position == previous_teleport_position:
		global_position = movement_points.pick_random().global_position
	previous_teleport_position = global_position


func _on_random_teleport_timer_timeout() -> void:
	# Randomly teleport if not panicking
	if $KingStateMachine.current_state is KingVulnerableState:
		return
	randomly_teleport()

func hurt(damage_event:DamageEvent) -> void:
	if $KingStateMachine.current_state is not KingVulnerableState:
		return
	health -= damage_event.damage
	print("king_boss.gd: Health lowered to %s/%s" % [health, max_health])
