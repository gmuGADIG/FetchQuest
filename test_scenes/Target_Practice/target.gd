extends Node2D

#path_follow: The path the target follows
#target_node: The character body that is the target
#target_collision: The collison bodu for the target
#timer: Countdown timer for the targets
#animation: the flashing animation when the time time is almost out
#hit_flash: The hit animation when the sword hit the target
#hitter: A collision detection when the sword hits the target
#marker: The sprite hit marker for when the sword hits the target
@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var target_node: Node2D = $"."
@onready var target_collision: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = Timer.new()
@onready var animation: AnimationPlayer = $Path2D/AnimationPlayer
@onready var hit_flash: AnimationPlayer = $Path2D/HitFlash
@onready var hitter: CollisionShape2D = $Path2D/PathFollow2D/Entered/HitArea
@onready var marker: Sprite2D = $Path2D/PathFollow2D/Sprite2D/Sprite2D

#Speed: The speed the targets move - Speed is war
#timeStart: The Start of the coutdown timer
#flashStart: The time at which the flash will start
#timeScale: The "flash" value for the target
#targetGroup, Assigns the target group for the target instance
#sprite The spride that the target has taken shape of
#collision_zone: The area in which the player must be in for the targets to move
#pressurePlate: The pressure plate object that the targets can be used with
#hitAll: Bool to shut down the targets after all of them have been hit

#Generally you would want the start, scale, flashStart to be the same throughout
#the targets. This will keep them "in sync" and not have any offsets on when they finish
#or when then start (Set one target and copy that one once you get the settings that you want)

@export var speed: int
@export var timeStart: int
@export var flashStart: int
@export var timeScale: float
@export var targetGroup: String = ""
@export var sprite: Sprite2D 
@export var collision_zone: Area2D
@export var pressurePlate: CharacterBody2D
@export var hitAll: bool

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
#flashingGroup: the group the target to help the code determine which target to manipulate
#sameTargets: a variable that gets added between instances to check if all the targets in the group
#have been hit. If so, they will shutdown
static var instances: Array[Node2D] = []
static var flashingGroup: String = ""
var sameTargets: int = 0

#This fucntion creates the main timer for the targets
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
#The main logic of control of the code lets you use area2d and pressure plates and they don't have any precidents over
#the other
func _process(delta: float) -> void:
	
	if(hitAll == false):
		if(pressurePlate != null && target_practice_signals.hitAll == 0 && inArea == false):
			_pressure_target_move(delta)
			if(pressurePlate.get_pressed() == false):
				_shutdown(targetGroup)
		elif (collision_zone != null && target_practice_signals.hitAll == 0):
			
			if(inArea == true):
				_target_move(delta)
		else:
			_shutdown(targetGroup)
			if(pressurePlate != null && pressurePlate.get_pressed() == false && inArea == false):
				target_practice_signals.hitAll = 0
	else:
		_shutdown(targetGroup)
	_check_time()

#This function is what makes the targets move
#Progress ratio conditional makes sures the target doesn't skip back to the start
#The skipping is possible to occur if the speed is high
#This function also has the targets flash, and plays that animation
func _target_move(delta:float) -> void:
	
	target_collision.global_position = sprite.global_position
	$Path2D/PathFollow2D/Entered/HitArea.global_position = sprite.global_position
	if (go == true && timeStart != 0 && inArea == true ):
		target_practice_signals.moving = true
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
	$Path2D/PathFollow2D/Entered/HitArea.global_position = sprite.global_position
	
	if(pressurePlate.get_pressed() && pressureActive == false && timer.time_left == 0):
		pressureActive = true
		_start_moving()
	elif (!pressurePlate.get_pressed() && target_practice_signals.moving == false):
		pressureActive = false
		_shutdown(targetGroup)
		target_practice_signals.hitAll = 0
		
	if (pressurePlate.get_pressed() && timer.time_left != 0):
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
	elif target_practice_signals.moving == false:
		stop_animation_on_all(targetGroup)

#This function calls the shutdown method when the timer runs out
func _on_timer_timeout() -> void:
	_shutdown(targetGroup)

#The hard coded int is how fast the flash animation can run, max is around 60-64, I have it limited to 34
#This function increases the rates of the flash animation by the timeScale variable
func _timescale() -> void:
	if(animation.speed_scale + timeScale <=34):animation.speed_scale += timeScale
	
#This fucntion checks all the targets in the called group have been hit and if they all have been hit then they shutdown
func _checkGroup(targetedGroup : String)	->  void:
	var groupCount: int = 0
	var SRT: int = 0
	for instance in instances:
		if instance.targetGroup == targetedGroup:
			groupCount+=1
			SRT += instance.sameTargets
	
	for instance in instances:
		if instance.targetGroup == targetedGroup:
			if(SRT >= groupCount):
				target_practice_signals.hitAll = 1
				#Uncomment this line of code if you want the targets to shutdown after the puzzle has been completed
				#instance.hitAll = true
				print("A condition for when all the targets have been hit...")
				print("Perhaps to be implemented later on if needed or removed")
		

#Function goes through the array and starts the animation for all of the instances for that group	
func play_animation_on_all(targetedGroup: String,anim_name: String) -> void:
	
	if flashingGroup == "":
		flashingGroup = targetedGroup
	for instance in instances:
		if instance.targetGroup == targetedGroup && instance.timer.time_left > 0 && instance.go == true:
			instance.animation.play(anim_name)
		if( instance.go == false && instance.targetGroup == flashingGroup):
			instance.animation.play(anim_name)
	

#Function goes through the array and stops the animation for all of the instances in the called group
static func stop_animation_on_all(targetedGroup: String) -> void:
	
	if flashingGroup == targetedGroup:
		flashingGroup = ""
		for instance in instances:
			if instance.targetGroup == targetedGroup:
				instance.animation.stop()
				
		

#This function starts the timer for the targets, ultimatly starting the target movements
func _start_moving() ->void:
	animation.speed_scale = 1
	timer.start(timeStart)
	go = true
	target_practice_signals.moving = true

		
#This function is called when the player enters the area2d and flags that they are in the area
func _on_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	inArea = true
	target_practice_signals.hitAll = 0
	_start_moving()
	
	
#This function calls the shutdown method to shutdown everything when the player exits the area
func _on_body_shape_exited(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	inArea = false
	_shutdown(targetGroup)
	target_practice_signals.hitAll = 0
	

#This function does as it says, it shuts down everything when the timer is done for the specific groups
#or if the player exits the area and resets any neccesary values
func _shutdown(groupName: String) -> void:
	
	target_practice_signals.moving = false
	
	for instance in instances:
		if(instance.targetGroup == groupName):
			instance.timer.stop()
			instance.go = false
			instance.sameTargets = 0
			instance.animation.speed_scale = 1
			instance.animation.play("RESET")
			instance.path_follow.progress = 0.0
			instance.dir = false
			if(hitAll == false):
				instance.marker.visible = false
			else:
				instance.marker.visible = true
			instance.path_follow.progress = 0.0
			if(pressurePlate!= null && pressurePlate.get_pressed() == true):
				instance.pressureActive = true
			else:
				instance.pressureActive = false
			target_collision.global_position = sprite.global_position
			hitter.global_position = target_collision.global_position
			instance.flashingGroup = ""
		
#Detects if the sword hit the target. One way to do it anyways
#Then plays a flash animation on the target
func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "ThrownSword" && go == true):
		if(sameTargets != 1): sameTargets = 1
		
		marker.visible = true
		hit_flash.speed_scale = 5
		hit_flash.play("HitFlash")
		await get_tree().create_timer(.5).timeout
		
		hit_flash.stop()
		hit_flash.play("RESET")
		_checkGroup(targetGroup)
