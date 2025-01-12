extends Area2D

var speed = 700
var deceleration = 600
var velocity = Vector2()
var countdown = 0
var enemy

var puddle_scene = preload("res://scenes/Puddle.tscn")

static var puddles = []

func _ready() -> void:
	look_at(get_global_mouse_position())
	
	velocity = transform.x * speed

func _physics_process(delta):
	
	if velocity.length() > 0:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	if countdown > 0:
		countdown -= 1
	elif is_instance_valid(enemy):
		enemy.modulate = Color(1, 1, 1)
	
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
	enemy = body
	if body.name.contains("Enemy"):
		body.health -= GlobalVariables.damage * randf_range(0.7, 1.3)
		body.modulate = Color(5, 0, 0)
		countdown = 20
