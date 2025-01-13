extends Timer

var sec = 0
var min = 0
var h = 0
var time = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timeout() -> void:
	start()
	sec += 1
	time += 1
	if sec >= 59:
		min += 1
		sec = 0
	if min >= 59:
		h += 1
		min = 0
	if h > 0:
		$"../UI/Timer".text = str("%02d" % h, ":", "%02d" % min, ":", "%02d" % sec)
	else:
		$"../UI/Timer".text = str("%02d" % min, ":", "%02d" % sec)
		
