extends "res://Classes/Movable.gd"

tool

var time_passed = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path_to_city = [Vector2(1,1), Vector2(1,1)]

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.
  
func _process(time):
  pass

func time_step():
  if len(path_to_city) > 0:
    do_move(path_to_city.pop_back())

