extends Camera2D

@export var tilemapBackground: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	set_camera_limits()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_camera_limits():
	var mapRect = tilemapBackground.get_used_rect()
	var tileSize = tilemapBackground.cell_quadrant_size
	var worldSizeInPixels = mapRect.size * tileSize

#	limit_left = 0
#	limit_top = 0
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
