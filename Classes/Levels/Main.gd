extends Node2D

var level_num = 0
var levels = [
  "TitleScreen",
  "Intro",
  "WarCutscene1",
  "WarCutscene2",
  "FirstBridge",
  "IslandWar",
  "Island2"
]

# Called when the node enters the scene tree for the first time.
func _ready():
  start_level()
  
func setup_level(level):
  level.connect("complete_level", self, "_next_level")
  level.connect("restart_level", self, "_restart_level")

func start_level():
  var next_level_resource = load("res://Classes/Levels/" + levels[level_num] + ".tscn")
  var next_level = next_level_resource.instance()
  setup_level(next_level)
  $Level.add_child(next_level)
  
func _restart_level():
  for level in $Level.get_children():
    $Level.remove_child(level)
    level.queue_free()
  start_level()

func _next_level():
  var level = $Level.get_child(0)
  $Level.remove_child(level)
  level.queue_free()
  level_num += 1
  start_level()

func _on_MusicIntro_finished():
  $MusicLoop.play()
