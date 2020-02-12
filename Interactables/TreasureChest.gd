extends StaticBody2D

onready var sfx_open_start = $SfxOpenStart
onready var sfx_open_end = $SfxOpenEnd
onready var sprite = $tiles

var _in_range: bool = false
var _item = null
var _item_in_motion: bool = false

var ui: CanvasLayer


func _ready() -> void:
	ui = GameState.current_level.get_node("UI")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and _in_range:
		open()
	if _item_in_motion:
		_move_item(delta)


func _on_Interacter_body_entered(body: Node) -> void:
	if body.name == 'Player':
		var btns: String = GameState.get_btns_for_action("interact")
		var msg: String = ""
		
		msg = "Press %s to flip the switch." % btns
		ui.set_msg(msg)
		_in_range = true


func _on_Interacter_body_exited(body: Node) -> void:
	ui.clear_msg()
	_in_range = false


func _get_item():
	if has_node("Key"):
		_item = get_node("Key")
	elif has_node("Potion"):
		_item = get_node("Potion")
	elif has_node("Ring"):
		_item = get_node("Ring")
	
	return _item


func _show_item() -> void:
	_item = _get_item()
	
	if _item:
		_item.visible = true
		_item_in_motion = true


func _move_item(delta: float) -> void:
	var direction = Vector2(0, -1)
	var distance = position.distance_to(_item.get_global_position())
	var speed = 40
	
	if distance >= 10:
		_item_in_motion = false
		yield(get_tree().create_timer(0.5), "timeout")
		_item.call_deferred("pickup")
		return
	
	_item.position += (direction * speed) * delta


func open() -> void:
	sfx_open_start.play()
	sprite.frame = 0
	yield(sfx_open_start, "finished")
	_show_item()
	sfx_open_end.play()
