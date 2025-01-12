class_name DamageEvent

enum DamageType {
	EnemyAttack = 1 << 0,
	Bomb = 1 << 1,
	Sword = 1 << 2,
}
var damage: int ## The amount of damage (in half hearts) the damage event should deal
var knockback: Vector2 ## Velocity added to thing being hit. This will only do anything if the enemy specifically handles it
var damage_type: int
func _init(attack_damage: int, attack_knockback := Vector2.ZERO, attack_type := DamageType.EnemyAttack) -> void:
	self.damage = attack_damage
	self.knockback = attack_knockback
	self.damage_type = attack_type
	
	
	
	
