class_name DamageEvent

enum KnockbackType {
	NONE,							## There is no knockback from this damage
	RELATIVE,						## Pushes enemies relative to a defined point
	FIXED							## Pushes enemies in a set direction
}

var damage: int						## The amount of damage (in half hearts) the damage event should deal
var knockback_type: KnockbackType
var damage_origin: Vector2			## Used for KnockbackType.RELATIVE, enemies are pushed relative to this position
var knockback_direction: Vector2	## Used for KnockbackType.FIXED, the direction that enemies should be pushed
var knockback_power: float				## A scalar that will be multiplied with the knockback direction



## Called when the DamageEvent is instantiated. Defines the nessesary values for the behavior of the KnockbackType 
func _init(damage: int, knockback_type: KnockbackType, vector: Vector2, knockback_power: float) -> void:
	self.damage = damage
	self.knockback_type = knockback_type
	
	match knockback_type:
		KnockbackType.RELATIVE:
			damage_origin = vector;
		KnockbackType.FIXED:
			knockback_direction = vector.normalized()
	
	self.knockback_power = knockback_power
	
	
## Calculates how the caller should be pushed.
static func calculate_knockback_vector(event: DamageEvent, target_location: Vector2) -> Vector2:
	if event.knockback_type == KnockbackType.NONE:
		return Vector2.ZERO
	
	if event.knockback_type == KnockbackType.RELATIVE:
		var direction :Vector2 = (target_location-event.damage_origin).normalized()
		return direction*event.knockback_power
		
	if event.knockback_type == KnockbackType.FIXED:
		return event.knockback_direction*event.knockback_power
	
	printerr("Error: knockback calculation had an unexpected knockback type")
	return Vector2.ZERO
		
	
	
	
	
