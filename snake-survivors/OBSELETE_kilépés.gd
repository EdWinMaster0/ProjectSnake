extends Button

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	get_tree().quit()
