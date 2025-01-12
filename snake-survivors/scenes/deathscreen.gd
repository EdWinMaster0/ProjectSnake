extends Button





func _on_pressed() -> void:
	GlobalVariables.health = GlobalVariables.max_health
	GlobalVariables.level = 1
	GlobalVariables.exp = 0
	GlobalVariables.exp_cap = pow(GlobalVariables.level, 2) * 50
	get_tree().change_scene_to_file("res://scenes/Map1.tscn")



func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")
