extends TextureButton


var spawn_duration: float
var distance_from_spawn

onready var item_name: String
onready var item_id: int = GlobalInventory.char_inventory.find(item_name)
onready var item_default_position: Vector2
onready var item_spawn_position: Vector2
onready var inventory_node = get_node("../..")
onready var items = get_node("..")


func _ready():
	$ItemHover.visible = false
	$ItemTexture.visible = true
	rect_position = item_default_position
	$ItemShade/ItemAnimation.play(item_name)
	$ItemTexture/ItemAnimation.play(item_name)
	
	if not item_spawn_position == Vector2(0, 0):
		
		distance_from_spawn = item_default_position.distance_to(item_spawn_position)
		spawn_duration =  sqrt(distance_from_spawn) / 16
		
		# When first created, the item slides in the inventory.
		$Tween.interpolate_property($ItemTexture, "position"
		, item_spawn_position - item_default_position - Vector2(16 , 16),
		Vector2(0, 0), spawn_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		inventory_node.item_spawn_positions[item_name] = Vector2(0, 0)
		# When first created, the item slowly appears.
		$Tween.interpolate_property($ItemTexture, "modulate"
		, Global.COLOR_TRANPARENT, Global.COLOR_DEFAULT, 
		spawn_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.interpolate_property($ItemShade, "modulate"
		, Global.COLOR_TRANPARENT, Global.COLOR_BLACK, 
		spawn_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		
		$ItemTexture.z_index = +32
		yield(get_tree().create_timer(spawn_duration), "timeout")
		$ItemTexture.z_index = 0
		
		$Tween.interpolate_property($ItemTexture, "modulate"
		, $ItemTexture.modulate, Global.COLOR_DEFAULT, 
		0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()


func _on_Item_mouse_entered():
	$ItemHover.visible = true
	$ItemTexture.modulate = Global.COLOR_DAY_HIGHLIGHT
	if GlobalInventory.item_used == "":
		$ItemShade.modulate = Global.COLOR_DEFAULT
	Global.mouse_hovering_count += 1
	Global.force_hand_cursor = true
	Global.mouse_hovering_inventory = true
	GlobalInventory.item_hovered = item_name


func _on_Item_mouse_exited():
	$ItemShade.modulate = Global.COLOR_BLACK
	$ItemHover.visible = false
	if not GlobalInventory.item_used == item_name:
		$ItemTexture.modulate = Global.COLOR_DEFAULT
	if Global.mouse_hovering_count > 0:
		Global.mouse_hovering_count -= 1
		Global.force_hand_cursor = false
		Global.mouse_hovering_inventory = false
		GlobalInventory.item_hovered = ""


func draw_item():
	$Tween.stop($ItemTexture, "modulate")
	$Tween.stop($ItemTexture, "position")
	$Tween.stop($ItemShade, "modulate")
	
	$ItemTexture.modulate = Global.COLOR_DEFAULT
	$ItemTexture.position = Vector2(0, 0)
	$ItemShade.modulate = Global.COLOR_BLACK
	
	GlobalInventory.is_using_item = true
	GlobalInventory.item_used = item_name
	
	$ItemTexture.z_index = +32
	$ItemTexture.modulate = Global.COLOR_DAY_HIGHLIGHT
	if item_name in ["cryopod_trap_key"]:
		$Sounds/Keys.play()
	if item_name in ["screwdriver"]:
		$Sounds/Tool.play()
	if item_name in ["map_module"]:
		$Sounds/PadModule.play()
	
	print("Char is using " + item_name)


func holster_item():
	GlobalInventory.is_using_item = false
	GlobalInventory.item_used = ""
	yield(get_tree(), "idle_frame")
	$ItemTexture.position = Vector2(0,0)
	$ItemTexture.z_index = 0
	
	$ItemHover.visible = true
	$ItemTexture.modulate = Global.COLOR_DAY_HIGHLIGHT
	$ItemShade.modulate = Global.COLOR_DEFAULT
	
	print("Char not using " + item_name)
	inventory_node.get_node("BagSound").play()


func _input(event):
	var specific_offset: Vector2
	if not Global.mouse_hovering_inventory and GlobalInventory.item_used in ["screwdriver"]:
		specific_offset = Vector2(-31, -28)
		
	if event is InputEventMouseMotion:
		if GlobalInventory.item_used == item_name:
			$ItemTexture.position = event.position - item_default_position + specific_offset - get_node("../..").position
