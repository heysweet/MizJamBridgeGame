extends "res://Classes/Movable.gd"

tool

var time_passed = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path_to_city setget set_path_to

# Called when the node enters the scene tree for the first time.
func _ready():
  path_to_city = []
  pass # Replace with function body.
  
func _process(time):
  pass

func set_path_to(arr):
  path_to_city = arr

func time_step():
  if len(path_to_city) > 0:
    do_move(path_to_city.pop_back())
