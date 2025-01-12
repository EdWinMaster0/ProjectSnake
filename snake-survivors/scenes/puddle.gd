extends Area2D

# Puddle start hidden
func _ready():
	hide()  # Hide the puddle initially

# This function will be called to show the puddle when the projectile disappears
func show_puddle():
	show()  # Make the puddle visible
