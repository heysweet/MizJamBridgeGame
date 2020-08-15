extends Sprite

tool

var width = 16
var height = 16

export var row : int = 0 setget set_row
export var col : int = 0 setget set_col

func set_row(new_val):
  row = new_val
  draw_me()
  
func set_col(new_val):
  col = new_val
  draw_me()
  
func draw_me():
  var x_pos = col * 16
  var y_pos = row  * 16
  region_rect = Rect2(x_pos, y_pos, width, height)

# Called when the node enters the scene tree for the first time.
func _ready():
  region_enabled = true
  pass # Replace with function body.
