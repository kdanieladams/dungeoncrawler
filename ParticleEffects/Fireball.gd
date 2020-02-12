extends KinematicBody2D

onready var sfx_fireball_start = $FireballStart
onready var sfx_fireball_end = $FireballEnd

var _colliding: bool = false
var _velocity = Vector2.ZERO
var _speed = 150
var direction = Vector2(1, 0)


func _ready() -> void:
	sfx_fireball_start.play()


func _physics_process(delta: float) -> void:
	_velocity = (direction * _speed) * delta
	var collision: KinematicCollision2D = move_and_collide(_velocity)
	
	if collision and not _colliding:
		var collider = collision.collider
		
		if collider.is_in_group("Enemies"):
			collider.die()
		
		_colliding = true
		_speed = 0
		$CPUParticles2D.explosiveness = 0.75
		sfx_fireball_end.play()
		yield(sfx_fireball_end, "finished")
		queue_free()
