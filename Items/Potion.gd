extends Area2D

onready var sfx_bottle = $Bottle
onready var sprite = $rings_and_potions

export(Enums.POTION_TYPE) var potion_type: int = Enums.POTION_TYPE.health
export var quantity: int = 25


func _ready() -> void:
	set_sprite()


func _on_body_entered(body: Node) -> void:
	if body.name == 'Player':
		effect()
		sfx_bottle.play()
		sprite.visible = false
		yield(sfx_bottle, "finished")
		queue_free()


func effect() -> void:
	match potion_type:
		Enums.POTION_TYPE.health:
			PlayerState.health += quantity
			PlayerState.health = min(PlayerState.health, PlayerState.full_health)
		
		Enums.POTION_TYPE.magic:
			PlayerState.magic += quantity
			PlayerState.magic = min(PlayerState.magic, PlayerState.full_magic)
			
		Enums.POTION_TYPE.strength:
			PlayerState.full_health += quantity
			PlayerState.health = PlayerState.full_health
		
		Enums.POTION_TYPE.willpower:
			PlayerState.full_magic += quantity
			PlayerState.magic = PlayerState.full_magic


func set_sprite() -> void:
	var new_rect: Rect2
	
	match potion_type:
		Enums.POTION_TYPE.health:
			new_rect = Rect2(0, 9, 8, 8) 	# red
		Enums.POTION_TYPE.magic:
			new_rect = Rect2(18, 9, 8, 8) 	# green
		Enums.POTION_TYPE.strength:
			new_rect = Rect2(27, 9, 8, 8) 	# brown
		Enums.POTION_TYPE.willpower:
			new_rect = Rect2(9, 9, 8, 8)	# blue
	
	sprite.region_rect = new_rect
