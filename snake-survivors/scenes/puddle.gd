extends Area2D
var enemies = []

func _ready():
	$AnimationPlayer.play("Splash")
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Splash":
		$AnimationPlayer.play("Puddle")

func _physics_process(delta: float) -> void:
	for enemy in enemies:
		if !enemy.has_shield:
			enemy.has_dot = true
			enemy.dot_linger = GlobalVariables.linger
			enemy.get_child(0).modulate = Color(5, 0, 0) # Indicate damage visually
		
func _on_body_entered(body: Node2D) -> void:
	# Only slows if the enemy is not yet in the enemies list
	if body.name.contains("Enemy") and not enemies.has(body):
		if not body.is_boss and not body.has_shield:
			body.is_slow = true
		enemies.append(body)
		
func _on_body_exited(body: Node2D) -> void:
	if body.name.contains("Enemy") and enemies.has(body):
		enemies.erase(body)
		if "is_slow" in body:
			body.is_slow = false
		body.get_child(0).modulate = Color(1, 1, 1) # Reset visual indicator
