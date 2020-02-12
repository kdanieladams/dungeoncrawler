extends Area2D

export(Enums.MAGIC_TYPE) var magic_type = Enums.MAGIC_TYPE.fireball

onready var sfx_pickup = $SfxPickup
onready var sprite = $rings_and_potions

var _beam: bool = false
var _effect_scene: PackedScene = null
var _one_shot: bool = false
var _self_target: bool = false


func _ready() -> void:
	_setup_magic()


func _setup_magic() -> void:
	if not sprite or sfx_pickup:
		sprite = $rings_and_potions
		sfx_pickup = $SfxPickup
	
	match magic_type:
		Enums.MAGIC_TYPE.fireball:
			_effect_scene = preload("res://ParticleEffects/Fireball.tscn")
			_one_shot = true
			sprite.region_rect = Rect2(0, 0, 8, 8) # red


func _shoot() -> void:
	var direction = Vector2.ZERO
	var effect = _effect_scene.instance()
	var player = GameState.current_level.get_node("Player")
	
	# Quad-directional
	direction = Vector2(-1, 0) if player.sprite.is_flipped_h() else Vector2(1, 0)
	if player._velocity.y != 0:
		direction = Vector2(0, 1) if player._velocity.y > 0 else Vector2(0, -1)
	
	if _one_shot:
		effect.position = player.position + (Vector2(8, 8) * direction)
		effect.direction = direction
		GameState.current_level.add_child(effect)
	elif _beam:
		pass


func pickup() -> void:
	# duplicating this class does not translate it's properties, for some reason...
	var dup = self.duplicate()
	
	dup.magic_type = self.magic_type
	dup._setup_magic()
	PlayerState.rings.insert(0, dup)
	
	sprite.visible = false
	sfx_pickup.play()
	yield(sfx_pickup, "finished")
	queue_free()


func use() -> void:
	if _one_shot or _beam:
		_shoot()
	elif _self_target:
		pass
