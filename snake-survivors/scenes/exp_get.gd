extends Area2D

@export var exp_amount = 100
@export var heal_amount = 100

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalVariables.exp += exp_amount
		GlobalVariables.health += heal_amount
		if GlobalVariables.health > GlobalVariables.max_health:
			GlobalVariables.health = GlobalVariables.max_health
		while GlobalVariables.exp >= GlobalVariables.exp_cap:
			GlobalVariables.exp -= GlobalVariables.exp_cap
			GlobalVariables.level += 1
			GlobalVariables.exp_cap = pow(GlobalVariables.level, 2) * 50
		get_parent().exps.erase(self)
		queue_free()
