extends Node

func _on_Player_time_step():
  var before_pos = {}
  var after_pos = {}
  var initial_str = {}
  for child in get_children():
    before_pos[child] = child.position
    initial_str[child] = child.rank
  for child in get_children():
    child.time_step()
    if !after_pos.has(child.target_position):
      after_pos[child.target_position] = []
    after_pos[child.target_position].append(child)
  for child in get_children():
    var prev_loc = before_pos[child]
    var curr_loc = child.target_position
    if len(after_pos[curr_loc]) > 1:
      print("on same square") 
      for new_resident in after_pos[curr_loc]:
        if !new_resident.same_team(child):
          child.take_damage(initial_str[new_resident])
      # There are multiple carts in this position,
      # check for conflicts
    if after_pos.has(prev_loc) && len(after_pos[prev_loc]) > 0:
      for new_resident in after_pos[prev_loc]:
        if new_resident == child:
          continue
        if before_pos[new_resident] == curr_loc:
          child.take_damage(initial_str[new_resident])
