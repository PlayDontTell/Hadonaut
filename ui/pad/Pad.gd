extends Node2D


onready var ui = get_node("..")
onready var current_chapter = ui.get_node("..")
var h_slider_value: float
var v_slider_value: float
var current_module: String = ""
var require_hand_cursor: bool = false

func _ready():
	$PadSprite.visible = false
	Global.pad_visible = false
	$PadSprite/Module.visible = false
	$PadSprite/MapModule.visible = false


# warning-ignore:unused_argument
func _process(delta):
	if Global.pad_visible:
		if require_hand_cursor:
			if $PadSprite/MapModule.visible:
				Global.force_hand_cursor = true
		else:
			Global.force_hand_cursor = false


func _on_ModuleConnection_mouse_entered():
	Global.mouse_hovering_count += 1
	require_hand_cursor = true


func _on_ModuleConnection_mouse_exited():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1
	require_hand_cursor = false


func _on_ModuleConnection_hide():
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1
	require_hand_cursor = false


func _on_ModuleConnection_pressed():
	if current_module == "":
		if GlobalInventory.is_using_item:
			var module = GlobalInventory.item_used
			if module in ["map_module"]:
				ui.get_node("Inventory").remove(module)
				current_module = module
				insert_module(module)
				yield(get_tree().create_timer(0.7), "timeout")
				if module == "map_module":
					$PadSprite/MapModule.visible = true
					$PadSprite/Module/Tween.interpolate_property(
					$PadSprite/MapModule, "modulate"
					, Global.COLOR_TRANPARENT, Global.COLOR_DEFAULT, 
					1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
					$PadSprite/Module/Tween.start()
					$PadSprite/MapModule.modulate =  Global.COLOR_TRANPARENT
					$PadSprite/MapModule.visible = true
	else:
		eject_module()
		if current_module == "map_module":
			$PadSprite/MapModule.visible = false
		yield(get_tree().create_timer(0.6), "timeout")
		ui.get_node("Inventory").add(current_module, Vector2(408, 135))
		current_module = ""


func insert_module(module_name):
	$PadSprite/Module.visible = true
	$PadSprite/Module/AnimationPlayer.play(module_name)
	$PadSprite/Module/Tween.interpolate_property($PadSprite/Module, "position",
	 Vector2(210, 7), Vector2(171, 7), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$PadSprite/Module/Tween.interpolate_property($PadSprite/Module, "modulate"
		, Global.COLOR_TRANPARENT, Global.COLOR_DEFAULT, 
		0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$PadSprite/Module/Tween.start()
	yield(get_tree().create_timer(0.6), "timeout")
	$PadSprite/Module/ModuleInsert.play()
	$PadSprite/Module.position = Vector2(170, 7)
	yield(get_tree().create_timer(0.1), "timeout")
	$PadSprite/AudioStreamPlayer2D.play()


func eject_module():
	$PadSprite/AudioStreamPlayer2D.stop()
	require_hand_cursor = false
	$PadSprite/Module/ModuleEject.play()
	$PadSprite/Module.position = Vector2(171, 7)
	yield(get_tree().create_timer(0.1), "timeout")
	$PadSprite/Module/Tween.interpolate_property($PadSprite/Module, "position",
	Vector2(171, 7), Vector2(210, 7), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$PadSprite/Module/Tween.interpolate_property($PadSprite/Module, "modulate"
		, Global.COLOR_DEFAULT, Global.COLOR_TRANPARENT, 
		0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$PadSprite/Module/Tween.start()
	
