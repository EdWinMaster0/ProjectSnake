extends Area2D

var deceleration = 600
var velocity = Vector2()
var countdown = []
var enemy = []
var until_pierce = 0
var puddle_scene = preload("res://scenes/Puddle.tscn")

static var puddles = []

func _ready() -> void:
	look_at(get_global_mouse_position())
	
	velocity = transform.x * GlobalVariables.p_speed


func _physics_process(delta):
	# Move until speed is under 1
	if velocity.length() > 0:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	# Countdown is the amount of frames the enemy is red
	for i in range(countdown.size() - 1, -1, -1):
		if countdown[i] > 0:
			countdown[i] -= 1
		else:
			if is_instance_valid(enemy[i]):
				enemy[i].get_child(0).modulate = Color(1, 1, 1)
			enemy.remove_at(i)
			countdown.remove_at(i)
	
	position += velocity * delta
	
	if velocity.length() < 1:
		create_puddle(position)
		queue_free()


func create_puddle(pos: Vector2) -> void:
	var puddle = puddle_scene.instantiate()
	get_parent().add_child(puddle)
	puddle.position = pos

	puddles.append(puddle)
	
	if puddles.size() > GlobalVariables.max_puddles:
		var oldest_puddle = puddles.pop_front()
		if oldest_puddle:
			oldest_puddle.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Enemy"):
		until_pierce += 1 # (until pierce cap)
		enemy.append(body)
		body.health -= GlobalVariables.damage * randf_range(0.85, 1.15)
		body.get_child(0).modulate = Color(5, 0, 0)
		countdown.append(20)
		# When pierce cap is reached
		if until_pierce == GlobalVariables.pierce:
			# At the enemy's position
			create_puddle(body.position)
			queue_free()
