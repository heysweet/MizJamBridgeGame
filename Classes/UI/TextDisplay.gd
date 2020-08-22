extends Control

export var display_string : String = "Test text." setget set_message
export var start_pos : Vector2 = Vector2.ZERO setget set_position
export var max_width : int = -1 setget set_max_width


var char_map = {
  '?' : {
    'rowCol' : Vector2(0, 0),
    'width' : 8
  },
  '!' : {
    'rowCol' : Vector2(0, 0),
    'width' : 6
  },
  '.' : {
    'rowCol' : Vector2(0, 0),
    'width' : 3
  },
  ' ' : {
    'rowCol' : Vector2(0, 0),
    'width' : 3
  },
  'i' : {
    'rowCol' : Vector2(0, 0),
    'width' : 5
  }
}

var min_row = 18
var min_col = 35
var num_cols = 12
var a_ord = 'a'.ord_at(0)

var renderable = null

tool

func set_max_width(width : int):
  max_width = width
  render_text()

func set_position(pos : Vector2, bool_value=true):
  start_pos = pos
  if renderable == null:
    renderable = load("res://Classes/Renderable.tscn")
  render_text()

func set_message(new_message : String):
  display_string = new_message
  if renderable == null:
    renderable = load("res://Classes/Renderable.tscn")
  render_text()

func create_renderable(row_col, pos):
  var new_renderable = renderable.instance()
  .add_child(new_renderable)
  new_renderable.set_row(row_col.y)
  new_renderable.set_col(row_col.x)
  new_renderable.position = pos
  print(new_renderable.position)

func render_character(character : String, pos : Vector2):
  var c = character.to_lower()
  var is_capitalized = c != character
  var width
  var row_col
  if character in char_map:
    var char_info = char_map[character]
    width = char_info['width']
    row_col = char_info['rowCol']
  else:
    var index = c.ord_at(0) - a_ord
    var row_num = floor(index / num_cols) + min_row
    var col_num = (index % num_cols) + min_col
    width = 8
    row_col = Vector2(row_num, col_num)
  create_renderable(row_col, pos)
  return Vector2(pos.x + width, pos.y)

func render_text():
  for child in get_children():
    child.queue_free()
  var pos = start_pos 
  for c in display_string:
    pos = render_character(c, pos)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
  render_text()
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
