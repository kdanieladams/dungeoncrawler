extends StaticBody2D

signal switched

onready var anim = $AnimationPlayer
onready var sprite = $Sprite

export var switch_on = false
export var toggleable = false

var ui: CanvasLayer = null
var in_range: bool = false


func _ready() -> void:
	ui = GameState.current_level.get_node("UI")
	
	if switch_on:
		sprite.frame = 2


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and in_range:
		switch()


func _on_Interacter_body_entered(body: Node) -> void:
	if body.name == 'Player':
		if toggleable or (not toggleable and not switch_on):
			var btns: String = GameState.get_btns_for_action("interact")
			var msg: String = ""
			
			msg = "Press %s to flip the switch." % btns
			ui.set_msg(msg)
			in_range = true


func _on_Interacter_body_exited(body: Node) -> void:
	if body.name == 'Player':
		ui.clear_msg()
		in_range = false


func switch() -> void:
	if !switch_on:
		anim.play("switch")
		switch_on = true
	elif toggleable:
		anim.play_backwards("switch")
		switch_on = false
	
	yield(anim, "animation_finished")
	emit_signal("switched", switch_on)
