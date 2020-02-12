extends StaticBody2D

onready var animation_player = $AnimationPlayer
onready var collision_shape = $CollisionShape2D
onready var sprite = $SlidingDoorSprite

export var open = false

var _moving: bool = false


func _ready() -> void:
	if open:
		sprite.frame = 3
		collision_shape.disabled = true
	else:
		sprite.frame = 0


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "open":
		collision_shape.disabled = true
	elif anim_name == "close":
		collision_shape.disabled = false
	
	_moving = false


func open() -> void:
	if !_moving and !open:
		animation_player.play("open")
		_moving = true
		open = true


func close() -> void:
	if !_moving and open:
		animation_player.play("close")
		_moving = true
		open = false
