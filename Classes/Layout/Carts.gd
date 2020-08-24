extends Node

signal card_kill

func _on_Player_time_step():
  var before_pos = {}
  var after_pos = {}
  var initial_str = {}
  var did_take_damage = false
  var children_cache = []
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
    # This card and another occupy the same position
    if len(after_pos[curr_loc]) > 1:
      for new_resident in after_pos[curr_loc]:
        if new_resident == child:
          continue
        if !new_resident.same_team(child):
          did_take_damage = true
          child.take_damage(initial_str[new_resident])
        else:
          if child.rank < new_resident.rank:
            # Destroy the weaker spawn
            child.take_damage(child.rank)
          else:
            # By our powers combined
            child.set_rank(initial_str[child] + new_resident.rank)
    # Two ships passed in the night, but it ended badly
    if after_pos.has(prev_loc) && len(after_pos[prev_loc]) > 0:
      for new_resident in after_pos[prev_loc]:
        if new_resident == child:
          continue
        if before_pos[new_resident] == curr_loc:
          did_take_damage = true
          child.take_damage(initial_str[new_resident])
  if did_take_damage:
    emit_signal("card_kill")
