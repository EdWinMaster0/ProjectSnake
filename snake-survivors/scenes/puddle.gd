extends Area2D

var do_damage = 0
var enemy= []

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if do_damage > 0:
		for i in enemy.size():
			enemy[i].health -=1
			enemy[i].modulate = Color(5, 0, 0)

func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Enemy"):
		enemy.append(body)
		do_damage += 1


func _on_body_exited(body: Node2D) -> void:
	if body.name.contains("Enemy"):
		enemy.erase(body)
		body.modulate = Color(1, 1, 1)
		do_damage -= 1
