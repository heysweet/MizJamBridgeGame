extends Navigation2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  var path = get_simple_path(Vector2(0,0), Vector2(10,10))
  path.remove(0)
  set_process(true)
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  var last_point =
  print(last_point)
  pass
