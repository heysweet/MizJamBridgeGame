extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass


func _on_Player_time_step():
  var before_pos = {}
  var after_pos = {}
  var initial_str = {}
  for child in get_children():
    before_pos[child.position] = child
    initial_str[child] = child.rank
  for child in get_children():
    child.time_step()
    after_pos[child.position] = child
  for child in get_children():
    if before_pos[child.position] != child:
      child.take_damage(initial_str[child]) 
