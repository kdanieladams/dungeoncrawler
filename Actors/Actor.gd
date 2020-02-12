extends KinematicBody2D

class_name Actor

signal collided

var _speed: int = 1700
var _velocity: Vector2 = Vector2.ZERO


func emit_collision() -> void:
	for i in get_slide_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		if collision:
			emit_signal('collided', collision, self)


func get_direction() -> Vector2:
	# Override this method in child class
	return Vector2.ZERO


func move(delta: float) -> void:
	_velocity = get_direction()
	_velocity = (_velocity * _speed) * delta
	_velocity = move_and_slide(_velocity)
