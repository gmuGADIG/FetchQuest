class_name OneWay extends StaticBody2D

# note: all the one-way code is handled in the player.
# this class simply tells the player a collider is a one-way, and is used to store the direction

## How far the player should move when jumping over a one-way
## At least a tile size (128), plus enough distance to get the player completely outside of the collider
static var JUMP_SIZE := Vector2(200.0, 200.0)

@export var direction: Vector2
