extends Node2D

export var display_string : String = "Test text." setget set_message
export var start_pos : Vector2 = Vector2.ZERO setget set_position
export var max_width : int = -1 setget set_max_width

var min_row = 18
var min_col = 35
var num_cols = 13
var a_ord = 'a'.ord_at(0)

const LINE_HEIGHT = 12

var char_map = {
  '?' : {
    'rowCol' : Vector2(37, 13),
    'width' : 8
  },
  '!' : {
    'rowCol' : Vector2(35, 13),
    'width' : 6
  },
  '.' : {
    'rowCol' : Vector2(46, 17),
    'width' : 4
  },
  ':' : {
    'rowCol' : Vector2(45, 17),
    'width' : 4
  },
  ' ' : {
    'rowCol' : Vector2(0, 0),
    'width' : 4
  },
  'i' : {
    'rowCol' : get_letter_row_col('i'),
    'width' : 6
  },
  'l' : {
    'rowCol' : get_letter_row_col('l'),
    'width' : 10
  },
  'm' : {
    'rowCol' : get_letter_row_col('m'),
    'width' : 10
  },
  'w' : {
    'rowCol' : get_letter_row_col('w'),
    'width' : 10
  },
  'v' : {
    'rowCol' : get_letter_row_col('v'),
    'width' : 9
  },
  'o' : {
    'rowCol' : get_letter_row_col('o'),
    'width' : 9
  }
}

tool

func set_max_width(width : int):
  if max_width != width:
    max_width = width
    render_text()

func set_position(pos : Vector2, bool_value=true):
  if pos != start_pos:
    start_pos = pos
    render_text()

func set_message(new_message : String):
  if display_string != new_message:
    display_string = new_message
    render_text()

func create_renderable(row_col, pos) -> Renderable:
  var new_renderable = Renderable.new()
  .add_child(new_renderable)
  new_renderable.set_row(row_col.y)
  new_renderable.set_col(row_col.x)
  new_renderable.position = pos
  return new_renderable

func get_letter_row_col(character : String):
  var index = character.ord_at(0) - a_ord
  var row_num = floor(index / num_cols) + min_row
  var col_num = (index % num_cols) + min_col
  return Vector2(col_num, row_num)

func get_char_width(character : String):
  var width = 0
  var c = character.to_lower()
  var is_lower = c == character
  if c in char_map:
    width = char_map[c]['width']
  else:
    width = 9
  width -= int(is_lower) * 2
  return width

func render_character(character : String, pos : Vector2):
  var c = character.to_lower()
  var is_lower = c == character
  var row_col
  if c in char_map:
    var char_info = char_map[c]
    row_col = char_info['rowCol']
  else:
    row_col = get_letter_row_col(c)
  var width = get_char_width(character)
  var x_offset = 0.5 * width
  if max_width != -1 and pos.x + width > max_width:
    pos.x = start_pos.x
    pos.y += LINE_HEIGHT
  pos.x += x_offset
  if is_lower:
    pos.y += 1.25
  var renderable : Renderable = create_renderable(row_col, pos)
  var y_offset = 0
  if is_lower:
    renderable.scale *= 0.75
    width = width * 0.75
    pos.y -= 1.25
  return Vector2(pos.x + x_offset, pos.y + y_offset)

func render_word(word, pos):
  if !line_fit(word, pos):
    pos.x = start_pos.x
    pos.y += LINE_HEIGHT
  for c in word:
    pos = render_character(c, pos)
  pos = render_character(' ', pos)
  
  return pos

func line_fit(word, pos):
  if max_width == -1:
    return true
  var width = 0
  for c in word:
    width += get_char_width(c)
  return pos.x + width < max_width

func render_text():
  for child in get_children():
    child.queue_free()
  var pos = start_pos 
  for word in display_string.split(' '):
    pos = render_word(word, pos)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
  render_text()
  create_renderable(Vector2(1, 1), Vector2(10, 10))
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
