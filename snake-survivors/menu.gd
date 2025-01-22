extends Control

func _physics_process(delta: float) -> void:
	get_parent().get_parent().get_parent().get_child(0).get_child(0).text = str("Death Counter: ", GlobalVariables.death_counter)

func _on_pressed() -> void:
	GlobalVariables._reset()
	get_tree().change_scene_to_file("res://scenes/Map1.tscn")



func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()
