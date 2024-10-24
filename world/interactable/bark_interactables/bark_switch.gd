extends Area2D

signal switch_activated(switch:Node2D)
signal switch_deactivated
var activated := false

var _off_sprite: Sprite2D
var _on_sprite: Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_off_sprite = get_node("Off")
	_on_sprite = get_node("On")
	
	_off_sprite.visible = !activated
	_on_sprite.visible = activated
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_entered(area: Area2D) -> void:
	activated = true
	switch_activated.emit(self)
	_on_sprite.visible = true
	_off_sprite.visible = false
	pass # Replace with function body.