extends Area2D

@export var exp_amount = 100

func _ready() -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	GlobalVariables.exp += exp_amount
	while GlobalVariables.exp >= GlobalVariables.exp_cap:
		GlobalVariables.exp -= GlobalVariables.exp_cap
		GlobalVariables.level += 1
		GlobalVariables.exp_cap = pow(GlobalVariables.level, 2) * 50
	queue_free()
