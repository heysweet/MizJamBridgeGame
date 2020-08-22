extends Node2D

tool

const width = 16
const height = 16
const resource_pack = preload("res://1bitpack_kenney_1.1/Tilesheet/monochrome_transparent_packed.png")
var sprite : Sprite = Sprite.new();
var clip = 1.0

export var row : int = 1 setget set_row
export var col : int = 1 setget set_col

#progress from 0 to 1 where 1 is totally invisible
func bottom_clip(progress : float):
  clip = clamp(1.0 - progress, 0.0, 1.0)
  draw_me()

func _init():
  sprite.texture = resource_pack
  sprite.region_enabled = true
  add_child(sprite)
  draw_me()
  
func set_row(new_val):
  row = new_val
  draw_me()
  
func set_col(new_val):
  col = new_val
  draw_me()
  
func draw_me():
  var x_pos = col * 16
  var y_pos = row  * 16  
  sprite.region_rect = Rect2(x_pos, y_pos, width, height * clip)

# Called when the node enters the scene tree for the first time.
func _ready():
  pass
