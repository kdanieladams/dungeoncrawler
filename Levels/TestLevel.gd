extends LevelNodeDungeon

onready var bgm = $LevelAudio/BGM
onready var sliding_door_1 = $SlidingDoor
onready var sliding_door_2 = $SlidingDoor2
onready var sliding_door_3 = $SlidingDoor3


func _ready() -> void:
	PlayerState.health = 75


func _on_Player_collided(collision: KinematicCollision2D, player: KinematicBody2D) -> void:
	.handle_player_collision(collision, player)


func _on_Switch_switched(switch_on: bool) -> void:
	if switch_on:
		sliding_door_1.open()
	else:
		sliding_door_1.close()


func _on_Switch2_switched(switch_on: bool) -> void:
	if switch_on:
		sliding_door_2.open()
		sliding_door_3.open()
	else:
		sliding_door_2.close()
		sliding_door_3.close()
