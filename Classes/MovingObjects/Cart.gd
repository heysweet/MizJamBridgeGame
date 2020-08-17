extends "res://Classes/Movable.gd"

tool

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
enum Rank {ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING}

export(Suit) var suit = Suit.HEART setget set_suit
export(Rank) var rank = Rank.ACE setget set_rank

var time_passed = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path_to_city

func set_suit(new_suit):
  $Card2.rank = new_suit
  
func set_rank(new_rank):
  $Card2.rank = new_rank

# Called when the node enters the scene tree for the first time.
func _ready():
  path_to_city = []
  pass # Replace with function body.
  
func _process(time):
  pass

func set_path_to(arr : Array):
  var seen_nodes = {}
  seen_nodes[var2str(Vector2(tile_col, tile_row))] = true
  var new_arr = []
  for pt in arr:
    var v = Vector2(int(round(pt.x / 16)), int(round(pt.y / 16)))
    var v_str = var2str(v)
    if !(v_str in seen_nodes):
      seen_nodes[v_str] = true
      new_arr.append(v)
  print(new_arr)
  path_to_city = new_arr

func time_step():
  if len(path_to_city) > 0:
    do_move_to(path_to_city.pop_front())
