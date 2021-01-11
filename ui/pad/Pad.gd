extends Node2D


onready var hud = get_node("../../..")
onready var current_chapter = hud.get_node("..")
var h_slider_value: float
var v_slider_value: float
var current_module: String = ""
var require_hand_cursor: bool = false

func _ready():
	$PadSprite/Module.visible = false
	$PadSprite/Modules.modulate = Global.COLOR_TRANPARENT
	$PadSprite/Modules/MapModule.visible = false


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
				$PadSprite/Module/Tween.interpolate_property($PadSprite/Modules, "modulate", Global.COLOR_TRANPARENT, Global.COLOR_DEFAULT, 1.0)
				$PadSprite/Module/Tween.interpolate_property($PadSprite/Background, "modulate", Global.COLOR_DEFAULT, Global.COLOR_BLACK, 1.0)
				$PadSprite/Module/Tween.start()
				hud.inventory.remove(module)
				current_module = module
				insert_module(module)
				yield(get_tree().create_timer(0.7), "timeout")
				if module == "map_module":
					Global.add_to_playthrough_progress("You inserted the map module in the pad.")
					$PadSprite/Modules/MapModule.visible = true
					$PadSprite/Module/Tween.interpolate_property(
					$PadSprite/Modules/MapModule, "modulate"
					, Global.COLOR_TRANPARENT, Global.COLOR_DEFAULT, 
					1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
					$PadSprite/Module/Tween.start()
					$PadSprite/Modules/MapModule.modulate =  Global.COLOR_TRANPARENT
					$PadSprite/Modules/MapModule.visible = true
	else:
		eject_module()
		if not current_module == "":
			$PadSprite/Module/Tween.interpolate_property($PadSprite/Modules, "modulate", Global.COLOR_DEFAULT, Global.COLOR_TRANPARENT, 1.0)
			$PadSprite/Module/Tween.interpolate_property($PadSprite/Background, "modulate", Global.COLOR_BLACK, Global.COLOR_DEFAULT, 1.0)
			$PadSprite/Module/Tween.start()
			if current_module == "map_module":
				$PadSprite/Modules/MapModule.visible = false
		yield(get_tree().create_timer(0.6), "timeout")
		hud.inventory.add(current_module, Vector2(408, 135))
		current_module = ""


func insert_module(module_name):
	$PadSprite/Module.visible = true
	$PadSprite/Module/AnimationPlayer.play(module_name)
	$PadSprite/Module/Tween.interpolate_property($PadSprite/Module, "position",
	 Vector2(190, 3), Vector2(160, 3), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$PadSprite/Module/Tween.interpolate_property($PadSprite/Module, "modulate"
		, Global.COLOR_TRANPARENT, Global.COLOR_DEFAULT, 
		0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$PadSprite/Module/Tween.start()
	yield(get_tree().create_timer(0.6), "timeout")
	$PadSprite/Module/ModuleInsert.play()
	$PadSprite/Module.position = Vector2(159, 3)
	yield(get_tree().create_timer(0.1), "timeout")
	$PadSprite/PadBuzzingSound.play()


func eject_module():
	$PadSprite/PadBuzzingSound.stop()
	require_hand_cursor = false
	$PadSprite/Module/ModuleEject.play()
	$PadSprite/Module.position = Vector2(160, 3)
	yield(get_tree().create_timer(0.1), "timeout")
	$PadSprite/Module/Tween.interpolate_property($PadSprite/Module, "position",
	Vector2(160, 3), Vector2(190, 3), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	$PadSprite/Module/Tween.interpolate_property($PadSprite/Module, "modulate"
		, Global.COLOR_DEFAULT, Global.COLOR_TRANPARENT, 
		0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$PadSprite/Module/Tween.start()
