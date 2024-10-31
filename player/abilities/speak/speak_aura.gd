extends Area2D

var damage: float

func set_damage(val: float) -> void:
	damage = val
	

func _on_body_entered(body: Node2D) -> void:
	print("Barked at " + body.name)
	if(body is CharacterBody2D):
		var charbody: CharacterBody2D = body
		if(charbody.get_collision_layer_value(3)):
			if(charbody.has_method("hurt")):
				charbody.hurt(DamageEvent.new(2))
			else:
				printerr("Aura collided with an enemy that does not have a hurt script!")
				
			if(charbody.has_method("stun")):
				charbody.stun()
			else:
				printerr("Aura collided with an enemy that does not have a stun script!")
			
			
	if(body is Area2D):
		var area2D: Area2D = body
		if(area2D.get_collision_layer_value(3)):
			if(area2D.has_method("stun")):
				print("I should be stunning an Area 2D")
				area2D.stun()
			
	pass # Replace with function body.
