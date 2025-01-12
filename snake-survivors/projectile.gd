extends Area2D

var speed = 700

func _ready() -> void:
	look_at(get_global_mouse_position())
	

func _physics_process(delta):
	position += transform.x * speed * delta
