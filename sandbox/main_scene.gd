extends Node3D

var red_light_green_light_timer = Timer.new()
var is_green_light: bool = true
@onready var penguin_head = $penguin_head
var tree_is_paused: bool
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
  Globals.scene_holder = get_parent()
  Globals.main_world_level = self
  randomize()
  
  red_light_green_light_timer.name = "RedLightGreenLightTimer"
  red_light_green_light_timer.set_one_shot(true)
  red_light_green_light_timer.connect("timeout", red_light_green_light)
  add_child(red_light_green_light_timer)
  red_light_green_light_timer.start(6)
  



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func red_light_green_light() -> void:
  is_green_light = not is_green_light
  if is_green_light:
    penguin_head.rotate(Vector3(0, 1, 0), PI)
  elif not is_green_light:
    penguin_head.rotate(Vector3(0, 1, 0), -PI)
  red_light_green_light_timer.start()
  

func launch_minigame() -> void:
  var minigame_event = 2
  var minigame
  match minigame_event:
    Globals.MINIGAMES.QUIZZ:
      tree_is_paused = true
      get_tree().paused = true
      minigame = load("res://sandbox/quizz_minigame.tscn").instantiate()
      minigame.position = player.position - Vector3(0,0,2)
      add_child(minigame)
      Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    Globals.MINIGAMES.SLEDDING:
      minigame = load("res://sandbox/Slope_mini_game.tscn").instantiate()
      Globals.scene_holder.remove_child(self)
      Globals.scene_holder.add_child(minigame)
    Globals.MINIGAMES.SNOWBALL_FIGHT:
      minigame = load("res://sandbox/SnowballFight_minigame.tscn").instantiate()
      Globals.scene_holder.remove_child(self)
      Globals.scene_holder.add_child(minigame)
      
    


func unfreeze(p_node) -> void:
  tree_is_paused = false
  get_tree().paused = false
  remove_child(p_node)
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  red_light_green_light()


func apply_minigame_result() -> void:
  if not Globals.minigame_succeeded:
    var player_position = player.position
    player_position.z = 0
    player.position = player_position
    
func reinitialize_level() -> void:
  red_light_green_light_timer.start()
  player.is_in_movement = false
  apply_minigame_result()
