extends Node2D

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
var suit_colors = [Color("#66CCEE"), Color("#228833"), Color("#CCBB44"), Color("#AA3377")]

enum State {NORMAL = 0, DESTROYING, DESTROYED}
var state = State.NORMAL
var shake_amount = 1.3
var shake_frequency = 29
var fall_speed = 4
var destroy_time = 0
var disappear_time = 1.6
var base_position = Vector2.ZERO

signal start_city_destroy
signal city_destroyed

tool

export(Suit) var suit = Suit.HEART setget set_suit
export var tile_row : int = 0 setget set_tile_row
export var tile_col : int = 0 setget set_tile_col

func set_tile_col(col):
  tile_col = col
  position.x = 16 * tile_col
  
func set_tile_row(row):
  tile_row = row
  position.y = 16 * tile_row

func set_suit(new_suit):
  suit = new_suit
  modulate = suit_colors[suit]
  
func is_type(type):
  return type == "Card" or .is_type(type)
  
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func _process(delta):
  if state == State.DESTROYING:
    destroy_time += delta
    shake_amount += 0.001
    shake_frequency -= 0.003
    position.x = base_position.x + (sin(destroy_time * shake_frequency) * shake_amount)
    position.y += delta * fall_speed
    $CityRenderable.bottom_clip(destroy_time / disappear_time)
    if destroy_time > disappear_time:
      position = base_position
      state = State.DESTROYED
      emit_signal("city_destroyed")

func destroy_city():
  state = State.DESTROYING
  base_position = position
  destroy_time = 0
  emit_signal("start_city_destroy")

func _on_City2_body_entered(body):
  if !(body is TileMap):
    destroy_city()
