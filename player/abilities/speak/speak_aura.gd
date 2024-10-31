class_name SpeakAura
extends Area2D

var damage: float

func set_damage(val: float) -> void:
	damage = val
	

func _on_body_entered(body: Node2D) -> void:
	_handle_collision(body)


func _on_area_entered(area: Area2D) -> void:
	_handle_collision(area)

func _handle_collision(body : CollisionObject2D) -> void:
	if(body.get_collision_layer_value(3)): #Enemy Layer
		if(body.has_method("hurt")):
			body.hurt(DamageEvent.new(2))
		else:
			printerr("Aura collided with an enemy that does not have a hurt script!")
			
		if(body.has_method("stun")):
			body.stun()
		else:
			printerr("Aura collided with an enemy that does not have a stun script!")
	print(body.name)
	if body.get_collision_layer_value(9): #Barkable Layer
		if body.has_method("on_bark"):
			body.on_bark(self)
