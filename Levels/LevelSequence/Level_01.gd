extends LevelNodeDungeon

onready var sliding_door_1 = $Interactables/SlidingDoor


#func _ready() -> void: 
#	pass


func _on_Player_collided(collision: KinematicCollision2D, player: KinematicBody2D) -> void:
	.handle_player_collision(collision, player)


func _on_Switch_switched(switch_on: bool) -> void:
	if switch_on:
		sliding_door_1.open()
