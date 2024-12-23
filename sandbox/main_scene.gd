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
  
  var timer = Timer.new()
  timer.set_one_shot(true)
  timer.connect("timeout", _set_traffic_lights_position)
  add_child(timer)
  timer.start(0.05)
  
  randomize()
  
  red_light_green_light_timer.name = "RedLightGreenLightTimer"
  red_light_green_light_timer.wait_time = 3
  red_light_green_light_timer.set_one_shot(true)
  red_light_green_light_timer.connect("timeout", red_light_green_light)
  add_child(red_light_green_light_timer)
  red_light_green_light_timer.start()
  



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
 print(DisplayServer.window_get_size())

func red_light_green_light() -> void:
  is_green_light = not is_green_light
  if is_green_light:
    $TrafficLights/GreenLight.material.set_shader_parameter("current_color", Color("00cf4e")) # 00cf4e 004c03
    $TrafficLights/RedLight.material.set_shader_parameter("current_color", Color("700026")) # d1004e 700026
    penguin_head.rotate(Vector3(0, 1, 0), PI)
  elif not is_green_light:
    $TrafficLights/GreenLight.material.set_shader_parameter("current_color", Color("004c03"))
    $TrafficLights/RedLight.material.set_shader_parameter("current_color", Color("d1004e"))
    penguin_head.rotate(Vector3(0, 1, 0), -PI)
  red_light_green_light_timer.start()
  
func handle_minigame() -> void:
  $InfoBeforeMinigame.visible = true
  var timer = Timer.new()
  timer.set_one_shot(true)
  timer.process_mode = Node.PROCESS_MODE_ALWAYS
  timer.connect("timeout", launch_minigame)
  add_child(timer)
  timer.start(1.2)
  tree_is_paused = true
  get_tree().paused = true

func launch_minigame() -> void:
  tree_is_paused = false
  get_tree().paused = false
  $InfoBeforeMinigame.visible = false
  var minigame_event = randi() % 3
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
  red_light_green_light()
  player.is_in_movement = false
  apply_minigame_result()


func _set_traffic_lights_position() -> void:
  var curr_window_size = DisplayServer.window_get_size()
  print(curr_window_size.x * 0.67)
  $TrafficLights.position = Vector2(curr_window_size.x * 0.67, curr_window_size.y * 0.31)
  
  $InfoBeforeMinigame.position = Vector2(curr_window_size.x * 0.4, curr_window_size.y * 0.15)
