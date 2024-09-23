extends CharacterBody2D
class_name Item

@onready var pickup_area: TriggerArea = $PickupArea ## This is the area that determines where the item can be picked up from

var collector: Node2D              ## The node that is currently collecting the item

var physics_state: String = "idle" ## The state of the item that determines its physics behavior.
var speed: float                   ## The speed of the item for physics calculations. Set by glue_to and other similar functions
var acceleration: float            ## The acceleration used for physics calculations. Set by glue_to and other similar functions
var target: Node2D                 ## The target of the item for following/gluing. 

## Called whenever the pickup area is spawned.
func _ready() -> void:
	pickup_area.touched_by.connect(initiate_pickup)

## This function is called when a node enters the Area2D that defines its pickup area
func initiate_pickup(body: Node2D) -> void:
	pick_up(body)

## This function is called by the node that collected the item to make the item follow it.
func glue_to(body: Node2D, glue_strength: float) -> void:
	physics_state = "following"
	speed = glue_strength
	acceleration = 0
	target = body

## Unused function that makes the item ignore collisions with the environment layer.
func ignore_environment_collisions() -> void:
	set_collision_mask_value(1, false)  # Disable collision with certain layers (layer 1)
		
## This function is responsible for signaling the node that picked up the item.
func pick_up(body: Node2D) -> void:
	if (body.has_method("pickup_item")): # There may be a better way to do this.
		collector = body
		body.pickup_item(self)

## Handles the different physics states to modify the item.
func _physics_process(delta: float) -> void:
	match physics_state:
		"following":
			if target and is_instance_valid(target):
				# We don't normalize here so the speed is dependent on distance.
				velocity = (target.position - position) * speed
			else:
				speed = velocity.length()
				acceleration = delta * pow(speed, 2)/(2 * 50) # 25 is the slide distance (in pixels)
				physics_state = "idle"
		"idle":
			if (speed > 0):
				speed = max(0, speed - (acceleration))
			velocity = velocity.normalized() * speed
	move_and_slide()
