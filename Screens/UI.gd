extends CanvasLayer

onready var blackout_anim = $Control/Blackout/AnimationPlayer
onready var lbl_keys = $"Control/Key Display/Keys/Label"
onready var lbl_msg = $Control/LblMessage
onready var sprite_keys = $"Control/Key Display/Keys"
onready var sprite_hearts = get_node("Control/Hearts").get_children()

var curr_key_disp: int = 0
var cycle_keytype: bool = true
var keytype_cycle_time: float = 1.5
var _msg: String = ""
var _msg_ttl: float = 2.5


func _process(delta: float) -> void:
	update_ui(delta)


func clear_msg() -> void:
	_msg_ttl = 2.5
	_msg = ""


func cycle_keys(keytype_counts: Dictionary) -> void:
	if curr_key_disp >= keytype_counts.size():
		curr_key_disp = 0

	var keytype = keytype_counts.keys()[curr_key_disp]
	var count = keytype_counts[keytype]
	
	sprite_keys.frame = keytype
	lbl_keys.set_text("x %s" % count)
	curr_key_disp += 1
	
	cycle_keytype = false
	yield(get_tree().create_timer(keytype_cycle_time), "timeout")
	cycle_keytype = true


func fade_in() -> AnimationPlayer:
	blackout_anim.play("fade_in")
	return blackout_anim


func fade_out() -> AnimationPlayer:
	blackout_anim.play("fade_out")
	return blackout_anim


func set_msg(msg: String, ttl: float = 2.5) -> void:
	if msg.length() > 0:
		_msg = msg
		_msg_ttl = ttl


func update_hearts() -> void:
	var player_health = PlayerState.health
	var num_hearts = sprite_hearts.size()
	var full_heart = PlayerState.full_health / num_hearts
	var half_heart = full_heart / 2
	
	for heart in sprite_hearts:
		if player_health >= full_heart:
			player_health -= full_heart
			heart.frame = 0
		
		elif player_health >= half_heart:
			heart.frame = 1
			player_health -= half_heart
			
		else:
			heart.frame = 2


func update_keys() -> void:
	var keytypes = []
	var keytype_counts = {}
	
	for i in range(0, PlayerState.keys.size()):
		var key = PlayerState.keys[i]
		keytypes.append(key.keytype)
		if keytype_counts.has(key.keytype):
			keytype_counts[key.keytype] += 1
		else:
			keytype_counts[key.keytype] = 1
	
	if keytype_counts.size() <= 1:
		if keytype_counts.size() == 1:
			sprite_keys.frame = keytype_counts.keys()[0]
		else:
			sprite_keys.frame = 0
		
		lbl_keys.set_text("x %s" % PlayerState.keys.size())
	
	elif cycle_keytype:
		cycle_keys(keytype_counts)


func update_msg(delta: float) -> void:
	if _msg != "":
		_msg_ttl -= 1 * delta
		
		if _msg_ttl <= 0:
			clear_msg()
		
	lbl_msg.text = _msg


func update_ui(delta: float) -> void:
	update_keys()
	update_msg(delta)
	update_hearts()
