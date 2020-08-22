extends Camera2D
 
### Base Size of the Game ###
export var numTiles = Vector2(100, 100) setget update_camera
var zoomLevel = 1
var blackBarSize = Vector2()
var baseSize = Vector2()
var cameraSize = Vector2()
 
tool

func update_camera(size : Vector2):
  numTiles = size
  baseSize = size * 16
  cameraSize = get_best_camera_size(OS.window_size)
  var zoomLevel = min((cameraSize.x/baseSize.x),(cameraSize.y/baseSize.y))
  set_zoom(Vector2(zoomLevel, zoomLevel))
  blackBarSize = (cameraSize - baseSize) / 2

func _ready():
  update_camera(numTiles)
 
func get_best_camera_size(screenSize):
    var bestResizeX = floor(screenSize.x/baseSize.x)
    var bestResizeY = floor(screenSize.y/baseSize.y)
    
    if (bestResizeX <= bestResizeY):
        return screenSize / bestResizeX
    return screenSize / bestResizeY
