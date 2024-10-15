extends Node2D
#path_follow: The path the target follows
#target_node: The rigid body that is the target
#target_collision: The collison bodu for the target
#timer: Countdown timer for the targets
@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var target_node: Node2D = $"."
@onready var target_collision: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = Timer.new()
@onready var animation: AnimationPlayer = $AnimationPlayer
#Speed: The speed the targets move - Speed is war
#collision_zone: The area in which the player must be in for the targets to move
#sprite The spride that the target has taken shape of
#timeStart: The Start of the coutdown timer
#timeScale: The "flash" value for the target
#flashStart: The time at which the flash will start
#Generally you would want the start, scale, flashStart to be the same throughout
#the targets. This will keep them "in sync" and not have any offsets on when they finish
#or when then start
#targetGroup, Assigns the target group for the target instance
@export var speed: int
@export var timeStart: int
@export var flashStart: int
@export var timeScale: float
@export var targetGroup: String = ""
@export var sprite: Sprite2D 
@export var collision_zone: Area2D
@export var pressurePlate: CharacterBody2D

#dir: A bool for the direction of which way the target should be moving (left or right)
#go: Condition to start moving the targers
#pressureActive: Bool for if the pressure plate is being pressed
#inArea: Bool to show when the player is in the area2d
var dir: bool = false
var go: bool = false
var pressureActive: bool = false
var inArea: bool = false

#instances: an array of target instances to help sync the flash target animation
#Determines which group should be flashing
static var instances: Array[Node2D] = []
static var flashingGroup: String = ""

#This fucntion creates the main timer for the targers
#this also connects the timer, on entered and exit signals
func _ready() -> 	void:
	
	instances.append(self)
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
	if(collision_zone != null):
		collision_zone.body_shape_entered.connect(_on_body_shape_entered)
		collision_zone.body_shape_exited.connect(_on_body_shape_exited)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#Checks if there is a pressure plate in the the prior directory and calls the appropriate function
func _process(delta: float) -> void:
	
	if(pressurePlate == null || inArea == true):
		_target_move(delta)
	else:
		_pressure_target_move(delta)
	_check_time()
		

#This function is what makes the targets move
#Progress ratio conditional makes sures the target doesn't skip back to the start
#The skipping is possible to occur if the speed is high
#This function also has the targets flash, and plays that animation
func _target_move(delta:float) -> void:
	target_collision.global_position = sprite.global_position
	
	if (go == true && timeStart != 0):
		TargetPracticeSignals.moving = true
		if dir == false:
			path_follow.progress += speed * delta
			if path_follow.progress_ratio > .95:
				dir = true
		else:	
			path_follow.progress -= speed * delta
			if path_follow.progress_ratio < .1:
				dir = false
	
#Same Function as above, but pressure plate compatible
func _pressure_target_move(delta:float) -> void:
	target_collision.global_position = sprite.global_position
		
	if(pressurePlate.get_pressed() == true && !pressureActive):
		_on_pressure_press()
		pressureActive = true
	elif((pressurePlate.get_pressed() == false) && pressureActive):
		pressureActive = false
		_shutdown()
	
	elif timer.time_left == 0 && pressureActive:
		_shutdown()
		
	if (pressurePlate.get_pressed() && timeStart != 0):
		if dir == false:
			path_follow.progress += speed * delta
			if path_follow.progress_ratio > .95:
				dir = true
		else:	
			path_follow.progress -= speed * delta
			if path_follow.progress_ratio < .1:
				dir = false
	
#Checks the timer and sees if its appropriate to start the flash animation or stop the animation
func _check_time() -> void:
	if (timer.time_left < flashStart && timer.time_left > 0):
		play_animation_on_all(targetGroup, "TargetFlash")
	elif TargetPracticeSignals.moving == false:
		stop_animation_on_all(targetGroup)

#This function calls the shutdown method when the timer runs out
func _on_timer_timeout() -> void:
	_shutdown()

#The hard coded int is how fast the flash animation can run, max is around 60-64, I have it limited to 34
#This function increases the rates of the flash animation by the timeScale variable
func _timescale() -> void:
	if($"AnimationPlayer".speed_scale + timeScale <=34):$"AnimationPlayer".speed_scale += timeScale
	
#Function goes through the array and starts the animation for all of the instances	
static func play_animation_on_all(targetGroup: String,anim_name: String) -> void:
	
	if flashingGroup == "":
		flashingGroup = targetGroup
	for instance in instances:
		if instance.targetGroup == targetGroup && instance.timer.time_left > 0:
			instance.animation.play(anim_name)
		else:
			instance.animation.stop()

#Function goes through the array and stops the animation for all of the instances
static func stop_animation_on_all(targetGroup: String) -> void:
	
	if flashingGroup == targetGroup:
		flashingGroup = ""
		for instance in instances:
			if instance.targetGroup == targetGroup:
				instance.animation.stop()

#This function starts the timer for the targets, ultimatly starting the target movements
func _start_moving() ->void:
	
	$"AnimationPlayer".speed_scale = 1
	timer.start(timeStart)
	go = true
	TargetPracticeSignals.moving = true

#Called when a pressure plate is pressed
func _on_pressure_press()->void:
	_start_moving()
		
#This function is called when the player enters the area2d and flags that they are in the area
func _on_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	
	_start_moving()
	inArea = true
	
#This function calls the shutdown method to shutdown everything when the player exits the area
func _on_body_shape_exited(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	_shutdown()

#This function does as it says, it shuts down everything when the timer is done
#or if the player exits the area and resets any neccesary values
func _shutdown() -> void:
	
	TargetPracticeSignals.moving = false
	go = false
	dir = false
	inArea = false
	path_follow.progress = 0.0
	timer.stop()
	$"AnimationPlayer".speed_scale = 1
	$"AnimationPlayer".play("RESET")
	flashingGroup = ""

#Helps show when the target has been hit
func hurt(damage_event: DamageEvent)->void:
	print(damage_event.damage, " Ow, that hurt")
	
