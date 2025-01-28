extends Area2D

@export var exp_amount = 100
@export var heal_amount = 50

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GlobalVariables.exp += exp_amount
		GlobalVariables.health += heal_amount
		
		if GlobalVariables.health > GlobalVariables.max_health:
			GlobalVariables.health = GlobalVariables.max_health
		# Keep giving levels until no sufficient amount of exp remains
		while GlobalVariables.exp >= GlobalVariables.exp_cap:
			GlobalVariables.exp -= GlobalVariables.exp_cap
			GlobalVariables.level += 1
			GlobalVariables.exp_cap = pow(GlobalVariables.level, 2) * 50
			if GlobalVariables.level >= 5:
				GlobalVariables.skill_points += 1
			
		get_parent().exps.erase(self)
		queue_free()
