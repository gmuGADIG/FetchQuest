##switches that only work with speak_aura
class_name BarkSwitch extends Area2D

var activated := false

@onready var _off_sprite: Sprite2D = %Off
@onready var _on_sprite: Sprite2D = %On
# Called when the node enters the scene tree for the first time.
func _ready() -> void: #get sprite visuals make sure it is set to off
	_off_sprite.visible = !activated
	_on_sprite.visible = activated

#stun function gets called by speak_arua when they overlap
func stun() -> void:
	if !activated:
		activated = true
		get_parent().switch_hit(self) #tell bark_interactable_switch_manager it has been hit
		_on_sprite.visible = true
		_off_sprite.visible = false

#turns off switches, gets called by bark_interactable_switch_manager
func deactivate() -> void:
	activated = false
	_on_sprite.visible = false
	_off_sprite.visible = true
