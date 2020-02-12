extends Area2D

export(Enums.KEY_TYPE) var keytype

onready var sprite: Sprite = $Keys
onready var sfx_pickup: AudioStreamPlayer2D = $Pickup


func _ready() -> void:
	sprite.frame = keytype


func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		pickup()


func get_key_type() -> String:
	return Enums.KEY_TYPE.keys()[keytype]


func pickup() -> void:
	sfx_pickup.play()
	PlayerState.keys.insert(0, self.duplicate())
	sprite.visible = false
	yield(sfx_pickup, "finished")
	queue_free()
