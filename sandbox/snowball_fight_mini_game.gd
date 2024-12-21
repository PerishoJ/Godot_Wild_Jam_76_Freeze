extends Node3D

var locked: bool

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if not locked:
    if not get_tree().get_nodes_in_group("Team1") :
      Globals.minigame_succeeded = false
      var timer = Timer.new()
      timer.connect("timeout", _handle_scene_change)
      add_child(timer)
      timer.start(1)
      locked = true
    # end the game if you die
    if not is_instance_valid(player):
      Globals.minigame_succeeded = false
      _handle_scene_change()
  
    if not get_tree().get_nodes_in_group("Team2"):
      Globals.minigame_succeeded = true
      var timer = Timer.new()
      timer.connect("timeout", _handle_scene_change)
      add_child(timer)
      timer.start(1.5)
      locked = true



func _handle_scene_change() -> void:
  Globals.scene_holder.add_child(Globals.main_world_level)
  Globals.main_world_level.reinitialize_level()
