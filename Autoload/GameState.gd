extends Node

var _player_pos_override: Vector2 = Vector2.ZERO
var current_level = null
var tile_size = 8


func _ready() -> void:
	var root = get_tree().get_root()
	current_level = root.get_child(root.get_child_count() - 1)


func _deferred_goto_scene(path: String) -> void:
	var blackout_anim: AnimationPlayer = null
	var scene = ResourceLoader.load(path)
	var ui: CanvasLayer = null
	
	current_level.free()
	current_level = scene.instance()
	ui = current_level.get_node('UI')
	get_tree().get_root().add_child(current_level)
	get_tree().set_current_scene(current_level)
	
	if _player_pos_override != Vector2.ZERO:
		var player: Actor = current_level.get_node("Player")
		var tilemap: TileMap = current_level.tilemap
		player.position = tilemap.map_to_world(_player_pos_override)
		_player_pos_override = Vector2.ZERO
	
	blackout_anim = ui.fade_in()
	yield(blackout_anim, "animation_finished")
	PlayerState.freeze = false


func get_btns_for_action(action: String) -> String:
	var input_actions: Array = InputMap.get_action_list(action)
	var btns: String = ""
	
	for event in input_actions:
		var keyname = ""
		
		if event is InputEventKey:
			keyname = OS.get_scancode_string(event.scancode)
		elif event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				keyname = "LMB"
			elif event.button_index == BUTTON_RIGHT: 
				keyname = "RMB"
		
		btns += str(keyname + " / ")
	
	return btns.rstrip(" / ")


func goto_scene(path: String, player_pos: Vector2 = Vector2.ZERO) -> void:
	if player_pos != Vector2.ZERO:
		_player_pos_override = player_pos
	
	call_deferred("_deferred_goto_scene", path)
