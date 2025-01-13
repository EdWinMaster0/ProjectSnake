extends Button





func _on_pressed() -> void:
	GlobalVariables._reset()
	get_tree().change_scene_to_file("res://scenes/Map1.tscn")



func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")
