extends Node2D

#The scene for the bark AOE effect
@export var speak_aura: PackedScene	
#A non moving node container for the speak instance to attach to
#@export var projectile_container: Node2D


#The radius of the bark in pixels. applies to the transform scale with the formula: radius*2
@export var radius: float = 10
#The time in seconds the AOE should last
@export var speak_time: float = 1.0
#The time in seconds between barks. This time is independent from bark_time
@export var cooldown_time: float = 1.5
#A multiplier applied to the player movemnet speed when speaking
@export var movement_multiplier: float = 0.2
#The damage done on speak
@export var damage: float = 1.5


#Whether the player is speaking
var _is_speaking: bool = false
#Whether the speak is on cooldown
var _on_cooldown: bool = false


func _ready() -> void:
	scale = Vector2(2*radius, 2*radius)
	
func _process(delta: float) -> void:
	scale = Vector2(2*radius, 2*radius)
	pass
	

func speak() -> void:
	_is_speaking = true
	_on_cooldown = true
	#toggle the aura
	var speak_instance: Area2D = speak_aura.instantiate()
	speak_instance.set_damage(damage)
	#instance.top_level = true;
	add_child(speak_instance)
	#instance.top_level = true;	
	
	
	#schedule tasks to end the speak & cooldown
	var speak_timer := Timer.new()
	add_child(speak_timer)
	speak_timer.wait_time = speak_time
	speak_timer.one_shot = true
	var unspeak_call: Callable = Callable(self, "_on_unspeak").bind(speak_timer, speak_instance)
	speak_timer.timeout.connect(unspeak_call)
	speak_timer.start()
	
	var cooldown_timer := Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.one_shot = true
	var end_cooldown_call: Callable = Callable(self, "_end_cooldown").bind(cooldown_timer)
	cooldown_timer.timeout.connect(end_cooldown_call)  # Connect the timeout signal
	cooldown_timer.start()	
	
	

func _on_unspeak(speak_timer: Timer, speak_instance: Area2D) -> void:
	_is_speaking = false
	assert(is_instance_valid(speak_timer))
	speak_timer.queue_free()
	assert(is_instance_valid(speak_instance))
	speak_instance.queue_free()
	
	
		
func _end_cooldown(cooldown_timer: Timer) -> void:
	#toggle off the aura
	_on_cooldown = false
	assert(is_instance_valid(cooldown_timer))
	cooldown_timer.queue_free()
	pass
	
func is_speaking() -> bool:
	return _is_speaking
	
func on_cooldown() -> bool:
	return _on_cooldown
	
