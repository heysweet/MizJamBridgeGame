extends Camera2D
 
### Base Size of the Game ###
export var numTiles = Vector2(20, 20) setget update_camera
var zoomLevel = 1
var baseSize = Vector2()
var cameraSize = Vector2()
 
tool

func update_camera(size : Vector2):
  numTiles = size
  baseSize = size * 16
  cameraSize = get_best_camera_size(OS.window_size)
  var zoomLevel = max(1.0 / 18 * numTiles.x, 1.0 / 10 * numTiles.y)
  set_zoom(Vector2(zoomLevel, zoomLevel))

func _ready():
  update_camera(numTiles)
 
func get_best_camera_size(screenSize):
  var bestResizeX = floor(screenSize.x/baseSize.x)
  var bestResizeY = floor(screenSize.y/baseSize.y)
  
  if (bestResizeX <= bestResizeY):
      return screenSize / bestResizeX
  return screenSize / bestResizeY
