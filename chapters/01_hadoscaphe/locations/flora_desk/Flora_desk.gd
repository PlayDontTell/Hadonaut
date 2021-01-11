extends Node2D


onready var current_chapter = get_node("..")
onready var hud = current_chapter.hud
onready var inventory = hud.inventory


func _ready():
	initialize_light()
	if current_chapter.pad_taken:
		$PadInstance.queue_free()
	if current_chapter.map_module_taken:
		$MapModuleInstance.queue_free()


func initialize_light():
	if current_chapter.ship_power == "day":
		pass
	$AnimationPlayer.play(current_chapter.ship_power)
