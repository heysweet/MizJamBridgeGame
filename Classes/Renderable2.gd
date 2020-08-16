extends Node2D

tool

var width = 16
var height = 16
var resource_pack = preload("res://1bitpack_kenney_1.1/Tilesheet/monochrome_transparent_packed.png")
var sprite = Sprite.new()

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
  sprite.region_enabled = true
  sprite.texture = resource_pack
  sprite.region_rect = Rect2(x_pos, y_pos, width, height)

# Called when the node enters the scene tree for the first time.
func _ready():
  draw_me()
