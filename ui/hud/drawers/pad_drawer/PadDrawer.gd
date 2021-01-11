extends Node2D


onready var fade = get_node("../../Fade")

var last_ratio: float
var ratio_margin : float = 0.05
var ratio: float = 0.0
var shade_intensity: float = 1.0


func _ready():
	set_elements()


# warning-ignore:unused_argument
func set_elements():
	var handle_pos = $PadHandle.position
	
	if not $PadHandle.blocked_by_inventory_drawer:
		var start_to_end = abs($Start.position.y - $End.position.y)
		
		if handle_pos.y >= $Start.position.y - start_to_end * ratio_margin:
			ratio = stepify(abs(($Start.position.y - start_to_end * ratio_margin - handle_pos.y) / 
				(start_to_end * (1 - ratio_margin))), 0.01)
		
		if ratio != last_ratio:
			fade.modulate = Color(1, 1, 1, ratio * shade_intensity)
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Pad"), sqrt(ratio + 0.01) * 60 - 60)
			last_ratio = ratio
	
	$Pad.position.y = handle_pos.y - 112
