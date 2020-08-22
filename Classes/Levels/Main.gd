extends Node2D

var level_num = 1

# Called when the node enters the scene tree for the first time.
func _ready():
  setup_level(.get_node("Level1"))
  
func setup_level(level):
  level.connect("complete_level", self, "next_level")
  level.connect("restart_level", self, "restart_level")

func add_level(level_num):
  # Add the next level
  var next_level_resource = load("res://Classes/Levels/Level" + str(level_num) + ".tscn")
  var next_level = next_level_resource.instance()
  setup_level(next_level)
  .add_child(next_level)
  
func restart_level():
  var level = .get_child(0)
  .remove_child(level)
  level.call_deferred("free")
  add_level(level_num)

func next_level():
  var level = .get_child(0)
  .remove_child(level)
  level.call_deferred("free")
  level_num += 1
  add_level(level_num)