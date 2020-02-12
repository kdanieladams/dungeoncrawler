extends Area2D

class_name Teleporter

export var switch_scene: bool = false
export(String, FILE, "*.tscn") var next_scene_path
export var is_stairs: bool = false
export var teleport_to: Vector2 = Vector2.ZERO

onready var sfx_stairs = $ClimbingStairs

var ui: CanvasLayer = null


func _ready() -> void:
	ui = GameState.current_level.get_node("UI")


func _on_body_entered(body: Node) -> void:
	if body.name == 'Player':
		var player: KinematicBody2D = body
		
		PlayerState.freeze = true
		player.anim.stop()
		
		if is_stairs:
			sfx_stairs.play()
			yield(get_tree().create_timer(1), "timeout")
			sfx_stairs.stop()
		else: 
			var fall_anim = player.fall()
			player.position = position
			yield(fall_anim, "animation_finished")
		
		if not switch_scene:
			teleport(player)
		elif next_scene_path.length() > 0:
			var blackout_anim = ui.fade_out()
			yield(blackout_anim, "animation_finished")
			GameState.goto_scene(next_scene_path, teleport_to)


func teleport(player: KinematicBody2D) -> void:
	var blackout_anim: AnimationPlayer
	var delay: float = 0.5
	var teleport_pixels = Vector2.ZERO

	teleport_pixels = teleport_to * GameState.tile_size
	
	blackout_anim = ui.fade_out()
	yield(blackout_anim, "animation_finished")
	
	# teleport
	player.position = teleport_pixels
	player.anim.stop(true)
	
	blackout_anim = ui.fade_in()
	yield(blackout_anim, "animation_finished")
	
	PlayerState.freeze = false
