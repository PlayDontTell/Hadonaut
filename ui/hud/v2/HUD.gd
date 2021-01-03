extends Node2D


onready var inventory = get_node("")


func _ready():
	if not Global.DEV_MODE:
		$FPSrate.free()
