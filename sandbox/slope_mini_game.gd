extends Node3D

var race_timer = Timer.new()
var increment_count = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
  race_timer.set_one_shot(true)
  race_timer.connect("timeout", failed_race)
  add_child(race_timer)
  race_timer.start(25)
  increment_count.connect("timeout", increment_race_time)
  add_child(increment_count)
  increment_count.start(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  $Camera3D.position = $Player.position + Vector3(0, 5, 5)

func increment_race_time() -> void:
  $TimerCount.text = str(floor(race_timer.time_left))

func failed_race() -> void:
  Globals.minigame_succeeded = false
  var timer = get_tree().create_timer(1)
  timer.connect("timeout", _handle_scene_change)

func succeeded_race() -> void:
  Globals.minigame_succeeded = true
  var timer = get_tree().create_timer(1)
  timer.connect("timeout", _handle_scene_change)
  
func _handle_scene_change() -> void:
  #Globals.scene_holder.remove_child(self)
  queue_free()
  Globals.scene_holder.add_child(Globals.main_world_level)
  Globals.main_world_level.reinitialize_level()
