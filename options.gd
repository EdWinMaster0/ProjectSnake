extends Control



func _on_pressed() -> void:
	pass



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
