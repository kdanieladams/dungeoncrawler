extends Node2D

class_name LevelNode

onready var astar: AStar2D
onready var tilemap: TileMap = $TileMap
onready var ui = $UI

var _tiles: Array = []
var _used_rect: Rect2


func _ready() -> void:
	_tiles = tilemap.get_used_cells()
	_used_rect = tilemap.get_used_rect()
	
	OS.set_window_size(Vector2(1280, 720))
	OS.set_window_position(Vector2(320, 190))


func _build_astar() -> void:
	astar = AStar2D.new()
	for tile in _tiles:
		var id = _generate_astar_id(tile)
		astar.add_point(id, tile)


func _connect_astar(walkable_tiles: Array) -> void:
	for tile in _tiles:
		var id = _generate_astar_id(tile)

		if walkable_tiles.has(tilemap.get_cellv(tile)):
			# connect tiles directly adjacent in all directions that are also walkable
			for x in range(3):
				for y in range(3):
					var target = tile + Vector2(x - 1, y - 1)
					var target_id = _generate_astar_id(target)
					
					if not tile == target and astar.has_point(target_id):
						if walkable_tiles.has(tilemap.get_cellv(target)):
							astar.connect_points(id, target_id, true)


func _generate_astar_id(point: Vector2) -> int:
	var x = point.x - _used_rect.position.x
	var y = point.y - _used_rect.position.y

	return x + y * _used_rect.size.x


func generate_path(start: Vector2, end: Vector2, max_points: int = 0) -> Array:
	var path_map: Array
	var path_world: Array = []
	var half_cell_size: Vector2 = tilemap.cell_size / 2
	var start_tile: Vector2 = tilemap.world_to_map(start)
	var end_tile: Vector2 = tilemap.world_to_map(end)
	var start_id: int = _generate_astar_id(start_tile)
	var end_id: int = _generate_astar_id(end_tile)
	
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return path_world
	
	path_map = astar.get_point_path(start_id, end_id)
	
	for i in range(path_map.size()):
		if max_points == 0 || i < max_points:
			var point = path_map[i]
			var point_world = tilemap.map_to_world(point) + half_cell_size
			path_world.append(point_world)
		else:
			break
	
	return path_world
