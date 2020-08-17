extends "res://Classes/Movable.gd"

tool

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
enum Rank {ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING}

export(Suit) var suit setget set_suit
export(Rank) var rank setget set_rank

var time_passed = 0
var path_to_city = []

func set_suit(new_suit):
  suit = new_suit
  $Card2.suit = suit
  
func set_rank(new_rank):
  rank = new_rank
  $Card2.rank = rank
  
func _process(time):
  pass
  
func map_to_cell(value : int):
  return int(floor(value / 16))

func set_path_to(arr : Array):
  arr.pop_front()
  var seen_nodes = {}
  seen_nodes[var2str(Vector2(tile_col, tile_row))] = true
  var new_arr = []
  for pt in arr:
    var v = Vector2(map_to_cell(pt.x), map_to_cell(pt.y))
    var v_str = var2str(v)
    if !(v_str in seen_nodes):
      seen_nodes[v_str] = true
      new_arr.append(v)
  path_to_city = new_arr

func time_step():
  if len(path_to_city) > 0:
    do_move_to(path_to_city.pop_front(), Vector2.ZERO)
