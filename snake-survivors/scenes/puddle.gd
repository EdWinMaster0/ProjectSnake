extends Area2D

var do_damage = 0
var enemies = [] # List to track enemies inside the puddle
var DoT_trigger = 0 # Nerfing puddle damage
var slow_factor = 0.5 # Reduce enemy speed to 50% when slowed
var DoT_interval = 3 # Damage triggers every X frames

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if do_damage > 0:
		for enemy in enemies:
			if DoT_trigger == DoT_interval: # Apply damage periodically
				if "health" in enemy:
					enemy.health -= 1
					enemy.modulate = Color(5, 0, 0) # Indicate damage visually
				DoT_trigger = 0
			else:
				DoT_trigger += 1

func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Enemy") and not enemies.has(body):
		if "speed" in body:
			body.speed *= slow_factor # Apply the slow effect
		enemies.append(body)
		do_damage += 1

func _on_body_exited(body: Node2D) -> void:
	if body.name.contains("Enemy") and enemies.has(body):
		enemies.erase(body)
		if "speed" in body:
			body.speed /= slow_factor # Restore the original speed
		body.modulate = Color(1, 1, 1) # Reset visual indicator
		do_damage -= 1
