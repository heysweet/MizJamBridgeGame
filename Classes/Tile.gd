extends Node2D

var width = 16
var height = 16
export var row : int setget set_row
export var col : int setget set_col

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_position():
  return Vector2(col * width, row * height)

func set_row(new_row):
  row = new_row
  
func set_col(new_col):
  row = new_col

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
