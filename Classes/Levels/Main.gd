extends Node2D

var level_num = 1

# Called when the node enters the scene tree for the first time.
func _ready():
  setup_level(.get_node("Level1"))
  
func setup_level(level):
  level.connect("complete_level", self, "next_level")

func next_level():
  var level = .get_node("Level" + str(level_num))
  .remove_child(level)
  level.call_deferred("free")
  level_num += 1
  
  # Add the next level
  var next_level_resource = load("res://Classes/Levels/Level" + str(level_num) + ".tscn")
  var next_level = next_level_resource.instance()
  .add_child(next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
