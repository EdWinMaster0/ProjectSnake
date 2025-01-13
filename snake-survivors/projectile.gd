extends Area2D

var speed = 700
var deceleration = 600
var velocity = Vector2()
var countdown = []
var enemy = []

var puddle_scene = preload("res://scenes/Puddle.tscn")

static var puddles = []

func _ready() -> void:
	look_at(get_global_mouse_position())
	
	velocity = transform.x * speed

func _physics_process(delta):
	if velocity.length() > 0:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	for i in range(countdown.size() - 1, -1, -1):
		if countdown[i] > 0:
			countdown[i] -= 1
		else:
			if is_instance_valid(enemy[i]):
				enemy[i].modulate = Color(1, 1, 1)
			enemy.remove_at(i)
			countdown.remove_at(i)
	
	position += velocity * delta

	if velocity.length() < 1:
		create_puddle()
		queue_free()


func create_puddle() -> void:
	var puddle = puddle_scene.instantiate()
	get_parent().add_child(puddle)
	puddle.position = position

	puddles.append(puddle)
	
	if puddles.size() > 3:
		var oldest_puddle = puddles.pop_front()
		if oldest_puddle:
			oldest_puddle.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Enemy"):
		enemy.append(body)
		body.health -= GlobalVariables.damage * randf_range(0.7, 1.3)
		body.modulate = Color(5, 0, 0)
		countdown.append(20)
