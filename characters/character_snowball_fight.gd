extends CharacterBody3D


const SPEED = 5.0
var direction: Vector3
var target: CharacterBody3D
var is_targeted: bool
@onready var level: Node3D = get_parent()
@onready var area = $Area3D
@onready var reload_timer = $ReloadTimer
@onready var choose_new_position_timer = $ChooseNewPositionTimer
var new_position: Vector3
var fire_is_ready: bool = false
@onready var state_machine = $Penguin/AnimationTree.get("parameters/playback")

func _ready():
  randomize()
  var start_reload_timer = Timer.new()
  start_reload_timer.set_one_shot(true)
  start_reload_timer.connect("timeout", _make_fire_ready)
  add_child(start_reload_timer)
  start_reload_timer.start(randf() * 2)
  

func _physics_process(delta):
  if reload_timer.is_stopped() and fire_is_ready:
    if choose_new_position_timer.is_stopped():
      direction = (Vector3(randi_range(-30, 30), 0, -19.15) - position).normalized()
      choose_new_position_timer.start()
    var at_distance_enemies_array = area.get_overlapping_bodies()
    if at_distance_enemies_array:
      target = at_distance_enemies_array[randi() % at_distance_enemies_array.size()]
      launch_snowball(target)
      reload_timer.start()
  
  elif not reload_timer.is_stopped():
    if choose_new_position_timer.is_stopped():
      if reload_timer.wait_time < 2:
        direction = (Vector3(randi_range(-30, 30), 0, -19.15) - position).normalized()
      elif reload_timer.wait_time >= 2:
        if self in get_tree().get_nodes_in_group("Team1"):
          direction = (Vector3(randi_range(-30, 30), 0, 5)).normalized()
        if self in get_tree().get_nodes_in_group("Team2"):
          direction = (Vector3(randi_range(-30, 30), 0, -42)).normalized()
          pass
      choose_new_position_timer.start()
  
  velocity = direction * SPEED
  move_and_slide()



func launch_snowball(p_target) -> void:
  state_machine.travel("attack")
  var snowball = load("res://sandbox/snowball.tscn").instantiate()
  if self in get_tree().get_nodes_in_group("Team2"):
    snowball.collision_mask = 1
  
  var vector_to_target = (p_target.position - position)
  var vector_to_target_normalized = (p_target.position - position).normalized()
  snowball.position = position + vector_to_target_normalized * 3
  level.add_child(snowball)
  snowball.apply_central_impulse(vector_to_target * 1.2 + Vector3(0, 13, 0))

func remove_from_game() -> void:
  state_machine.travel("die")
  var timer = Timer.new()
  timer.connect("timeout", queue_free)
  add_child(timer)
  timer.start(1.5)

func _make_fire_ready() -> void:
  fire_is_ready = true
