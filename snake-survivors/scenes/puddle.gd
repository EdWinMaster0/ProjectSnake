extends Area2D
var do_damage = 0
var enemies = []

func _ready():
	$AnimationPlayer.play("Splash")
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "Splash":
		$AnimationPlayer.play("Puddle")

func _physics_process(delta: float) -> void:
	for enemy in enemies:
		enemy.has_dot = true
		enemy.get_child(0).modulate = Color(5, 0, 0) # Indicate damage visually
		
func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Enemy") and not enemies.has(body):
		if not body.is_boss:
			body.is_slow = true
		enemies.append(body)
		do_damage += 1
func _on_body_exited(body: Node2D) -> void:
	if body.name.contains("Enemy") and enemies.has(body):
		enemies.erase(body)
		if "is_slow" in body:
			body.is_slow = false
		body.get_child(0).modulate = Color(1, 1, 1) # Reset visual indicator
