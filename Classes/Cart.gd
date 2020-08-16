extends "res://Classes/Movable.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path_to_city = [Vector2(0,0),Vector2(1,0),Vector2(1,1),Vector2(1,2)]

# Called when the node enters the scene tree for the first time.
func _ready():
  do_move(path_to_city.pop_back())
  pass # Replace with function body.

  
func _process(time):
  # Try and move
  pass
  


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
