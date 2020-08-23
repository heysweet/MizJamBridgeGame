extends Node2D

export var display_string : String = "Test text." setget set_message
export var start_pos : Vector2 = Vector2.ZERO setget set_position
export var max_width : int = -1 setget set_max_width
export var enable_text_box = true setget set_enable_text_box
export var should_type = false

var invisible_letters = []
var typing_speed = 0.03
var typing_time = -1
var min_row = 18
var min_col = 35
var num_cols = 13
var a_ord = 'a'.ord_at(0)
var enable_char_split = false
var preview_pos = Vector2.ZERO

const LINE_HEIGHT = 12

tool

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
    'width' : 9
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

func set_max_width(width : int):
  if max_width != width:
    max_width = width
  if !.has_node("Letters"): return
  render_text()

func set_position(pos : Vector2, bool_value=true):
  if pos != start_pos:
    start_pos = pos
  if !.has_node("Letters"): return
  render_text()

func set_message(new_message : String):
  if display_string != new_message:
    display_string = new_message
  if !.has_node("Letters"): return
  render_text()
    
func set_enable_text_box(is_enabled):
  enable_text_box = is_enabled
  if !.has_node("Letters"): return
  render_text()

func create_renderable(row_col, pos) -> Renderable:
  if !.has_node("Letters"): return null
  var new_renderable = Renderable.new()
  $Letters.add_child(new_renderable)
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
  if enable_char_split and max_width != -1 and pos.x + width > max_width:
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
  if !.has_node("Letters"): return
  for child in $Letters.get_children():
    $Letters.remove_child(child)
    child.queue_free()
    
  var pos = start_pos 
  for word in display_string.split(' '):
    pos = render_word(word, pos)
  preview_pos = pos
   
func _draw():
  if enable_text_box:
    rect(preview_pos)
    
func rect(pos : Vector2):
  var outline = Color(0.4, 0, 0.35)
  var thickness = 1.0
  var poly = []
  var origin = start_pos
  origin.y -= 8
  var size = Vector2(max_width, pos.y + 12)
  var points = [
    origin,
    Vector2(origin.x, origin.y + size.y),
    origin + size,
    Vector2(origin.x + size.x, origin.y),
    origin
  ]
  for i in range(1, points.size()):
    draw_line(points[i-1], points[i], outline, thickness)

# Called when the node enters the scene tree for the first time.
func _ready():
  if !.has_node("Letters"): return
  render_text()
  if should_type and !Engine.editor_hint:
    invisible_letters = $Letters.get_children()
    for letter in invisible_letters:
      letter.visible = false

func _process(delta):
  typing_time += delta
  if typing_time > typing_speed:
    typing_time = 0
    var letter : Renderable = invisible_letters.pop_front()
    if letter != null:
      letter.visible = true
      var sound = $SoundTyping
      if (sound != null):
        sound.position = letter.position
        var random_variation = 0.12
        var min_val = 1.0 - random_variation
        sound.set_pitch_scale(min_val + (random_variation * 2 * randf()))
        sound.play()
