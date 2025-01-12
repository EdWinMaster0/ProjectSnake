extends Area2D

# Initial speed of the projectile
var speed = 700
# Deceleration rate
var deceleration = 600
# Velocity vector for the projectile
var velocity = Vector2()

func _ready() -> void:
	# Point the projectile towards the mouse
	look_at(get_global_mouse_position())

	
	# Initialize velocity to move in the direction the projectile is facing
	velocity = transform.x * speed

func _physics_process(delta):
	# Apply deceleration: reduce the velocity towards zero
	if velocity.length() > 0:  # only decelerate if there's movement
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	# Update position based on the velocity
	position += velocity * delta

	# Optionally, destroy the projectile when it's almost stopped
	if velocity.length() < 1:
		queue_free()
