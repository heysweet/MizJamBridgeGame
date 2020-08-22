extends "res://Classes/Movable.gd"

tool

enum Suit {HEART = 0, DIAMOND, CLUB, SPADE}
enum Rank {ACE = 1, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING}

export(Suit) var suit setget set_suit
export(Rank) var rank setget set_rank

var time_passed = 0
var path_to_city = []

func has_path():
  return len(path_to_city)

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

# Takes any movement path and adds horizontal/vertical movement to avoid diagonals
func ensure_manhattan_movement(arr : Array) -> Array:
  if len(arr) == 0:
    return arr
  var result = []
  var last_pt = arr[0]
  for pt in arr:
    if pt.x != last_pt.x && pt.y != last_pt.y:
      # Move horizonal
      result.append(Vector2(pt.x, last_pt.y))
    result.append(pt)
    last_pt = pt
  return result

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
  path_to_city = ensure_manhattan_movement(new_arr)

func take_damage(dmg : int):
  if rank - dmg <= 0:
    queue_free()
  else:
    set_rank(rank - dmg)

func same_team(obj):
  return $Card2.same_team(obj)

func time_step():
  if len(path_to_city) > 0:
    do_move_to(path_to_city.pop_front(), Vector2.ZERO)
