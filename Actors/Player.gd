extends Actor

onready var anim = $AnimationPlayer
onready var fireball_scene = preload("res://ParticleEffects/Fireball.tscn")
onready var sfx_effort = $Effort
onready var sprite = $Sprite


func _ready() -> void:
	_speed = 2000


func _physics_process(delta: float) -> void:
	if not PlayerState.freeze:
		move(delta)
		emit_collision()


func _process(delta: float) -> void:
	if not PlayerState.freeze:
		walk()
	if Input.is_action_just_pressed("interact"):
		sfx_effort.play()
	if Input.is_action_just_pressed("attack"):
		use_ring()


func fall() -> AnimationPlayer:
	anim.stop()
	anim.play("falling")
	return anim


func get_direction() -> Vector2:
	var inputX: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var inputY: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(inputX, inputY)


#func shoot_fireball() -> void:
#	var fireball = fireball_scene.instance()
#	var direction = Vector2(-1, 0) if sprite.is_flipped_h() else Vector2(1, 0)
#
#	if _velocity.y != 0:
#		direction = Vector2(0, 1) if _velocity.y > 0 else Vector2(0, -1)
#
#	fireball.position = position + (Vector2(10, 10) * direction)
#	fireball.direction = direction
#	GameState.current_level.add_child(fireball)


func use_key(keytype: int) -> bool:
	var key_to_remove: int = -1
	
	for i in range(PlayerState.keys.size()):
		var key = PlayerState.keys[i]
		if key.keytype == keytype:
			key_to_remove = i 
			break;
	
	if key_to_remove > -1:
		var key = PlayerState.keys[key_to_remove]
		key.queue_free()
		PlayerState.keys.remove(key_to_remove)
		return true
	
	return false


func use_ring() -> void:
	if PlayerState.rings.size() > 0:
		var ring = PlayerState.rings[0]
		ring.use()


func walk() -> void:
	if _velocity.x != 0 or _velocity.y != 0:
		anim.play("walk")
	else:
		anim.stop()
	
	if _velocity.x < 0:
		sprite.set_flip_h(true)
	elif _velocity.x > 0:
		sprite.set_flip_h(false)
