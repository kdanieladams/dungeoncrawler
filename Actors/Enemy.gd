extends Actor

const POINT_RADIUS = 4

onready var anim: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $characters
onready var pursuit_timer: Timer = $PursuitTimer

export var pursuit_wait: float = 1.5

var _item = null
var _level: LevelNode
var _player: KinematicBody2D
var _path: Array


func _ready() -> void:
	_item = _has_item()
	_speed = 1500
	_level = GameState.current_level
	_player = _level.get_node("Player")
	
	pursuit_timer.wait_time = pursuit_wait
	pursuit_timer.one_shot = true
	
	if _item:
		_item.get_node("CollisionShape2D").disabled = true
	
	call_deferred("_get_path")


func _physics_process(delta: float) -> void:
	move(delta)
	emit_collision()


func _process(delta: float) -> void:
	walk()


func _drop_item(item: Node2D) -> void:
	item.position = position
	item.visible = true
	GameState.current_level.add_child(item)


func _has_item():
	if has_node("Key"):
		_item = get_node("Key")
	elif has_node("Potion"):
		_item = get_node("Potion")
	elif has_node("Ring"):
		_item = get_node("Ring")
		
	
	return _item


func _get_path() -> void:
	if pursuit_timer.is_stopped() and _path.size() == 0:
		_path = _level.generate_path(position, _player.position, 3)
		pursuit_timer.start(pursuit_wait)


func get_direction() -> Vector2:
	var direction: Vector2
	
	if _path.size() > 0:
		var target = _path[0]
		direction = (target - position).normalized()
		
		if position.distance_to(target) < POINT_RADIUS:
			_path.remove(0)
			if _path.size() == 0:
				_get_path()
	
	return direction


func _on_PursuitTimer_timeout() -> void:
	_path = []
	_get_path()


func die() -> void:
	if _item:
		_item.get_node("CollisionShape2D").disabled = false
		_drop_item(_item.duplicate())

	_velocity = Vector2.ZERO
	queue_free()


func walk() -> void:
	if _velocity.x != 0 or _velocity.y != 0:
		anim.play("walk")
	else:
		anim.stop(true)
	
	if _velocity.x < 0:
		sprite.set_flip_h(true)
	elif _velocity.x > 0:
		sprite.set_flip_h(false)
