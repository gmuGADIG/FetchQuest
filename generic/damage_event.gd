class_name DamageEvent

var damage: int ## The amount of damage (in half hearts) the damage event should deal
var knockback: Vector2 ## Velocity added to thing being hit. This will only do anything if the enemy specifically handles it

func _init(attack_damage: int, attack_knockback := Vector2.ZERO) -> void:
	self.damage = attack_damage
	self.knockback = attack_knockback
	
	
	
	
