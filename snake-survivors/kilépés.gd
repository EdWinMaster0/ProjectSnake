extends Button

# Amikor a gomb csatlakozik a jelenetfához
func _ready() -> void:
	# Kapcsoljuk a "pressed" jelet a saját metódushoz Callable használatával
	connect("pressed", Callable(self, "_on_button_pressed"))

# A gomb megnyomásakor hívott metódus
func _on_button_pressed() -> void:
	get_tree().quit()
