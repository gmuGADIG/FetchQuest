class_name DamageEvent

enum KnockbackType {
	NONE,							## There is no knockback from this damage
	RELATIVE,						## Pushes enemies relative to a defined point
	FIXED							## Pushes enemies in a set direction
}

var damage: int						## The amount of damage (in half hearts) the damage event should deal
var force_type: KnockbackType
var damage_origin: Vector2			## Used for KnockbackType.RELATIVE, enemies are pushed relative to this position
var force_direction: Vector2		## Used for KnockbackType.FIXED, the direction that enemies should be pushed
var force: float



## Called when the DamageEvent is instantiated. Defines the nessesary values for the behavior of the KnockbackType 
func _init(damage: int, force_type: KnockbackType, vector: Vector2, force: float) -> void:
	self.damage = damage
	self.force_type = force_type
	
	match force_type:
		KnockbackType.RELATIVE:
			damage_origin = vector;
		KnockbackType.FIXED:
			force_direction = vector.normalized()
	
	self.force = force
	
	
## Calculates how the caller should be pushed.
static func calculate_force_vector(event: DamageEvent, target_location: Vector2) -> Vector2:
	if event.force_type == KnockbackType.NONE:
		return Vector2.ZERO
	
	if event.force_type == KnockbackType.RELATIVE:
		var direction :Vector2 = (target_location-event.damage_origin).normalized()
		return direction*event.force
		
	if event.force_type == KnockbackType.FIXED:
		return event.force_direction*event.force
	
	printerr("Error: force calculation had an unexpected force type")
	return Vector2.ZERO
		
	
	
	
	
