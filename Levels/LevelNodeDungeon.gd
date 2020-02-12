extends LevelNode

class_name LevelNodeDungeon

const TILE_DOOR: int = 5
const TILE_FLOOR: int = 1
const TILE_GATE: int = 6

onready var sfx_door_open: AudioStreamPlayer = $LevelAudio/DoorOpen
onready var sfx_gate_open: AudioStreamPlayer = $LevelAudio/GateOpen


func _ready() -> void:
	_build_astar()
	_connect_astar([TILE_FLOOR])


func handle_player_collision(collision: KinematicCollision2D, player: KinematicBody2D) -> void:
	var collider = collision.collider
	
	if collider is TileMap and collider.tile_set.resource_name == "DungeonTiles":
		var tile_pos: Vector2 = collider.world_to_map(player.position)
		var tile: int = collider.get_cellv(tile_pos)
		var tilemap: TileMap = collider
		
		if tile == TILE_DOOR and player.use_key(Enums.KEY_TYPE.smallBrassKey):
			tilemap.set_cellv(tile_pos, TILE_FLOOR)
			sfx_door_open.play()
		elif tile == TILE_GATE and player.use_key(Enums.KEY_TYPE.smallSilverKey):
			tilemap.set_cellv(tile_pos, -1)
			sfx_gate_open.play()
