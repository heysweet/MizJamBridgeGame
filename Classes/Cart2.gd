extends "res://Classes/Movable.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var path_to_city = [[0,0], [1,0],[1,1]]

# Called when the node enters the scene tree for the first time.
func _ready():
  on_step()
  pass # Replace with function body.
  
func on_step():
  if (len(path_to_city) > 0):
    var step = path_to_city.pop_back()
    .do_move(Vector2(step[0], step[1]))

  

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass