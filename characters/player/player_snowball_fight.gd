extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5

@onready var level = get_parent()
@onready var shapecast = $Camera_rig/Gimble/ShapeCast3D
@onready var reload_timer = $ReloadTimer


func _process(delta: float) -> void:
  if_the_player_wants_to_quite()

func if_the_player_wants_to_quite():
  if Input.is_key_pressed(KEY_ESCAPE):
    get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
    get_tree().quit()

func _physics_process(delta: float) -> void:
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta

  # Handle jump.
  if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var input_dir := Input.get_vector("left", "right", "up", "down")
  # Rotate to match the input
  var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  
  if direction:
    velocity = direction * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()

func _unhandled_input(event):
  if event is InputEventMouseButton:
    if event.button_index == 1:
      if event.pressed:
        if reload_timer.is_stopped():
          launch_snowball()
          reload_timer.start()



func launch_snowball() -> void:
  var initial_vector = Vector3(0, 0, -1) * $Camera_rig/Gimble/Camera3D.get_global_transform().basis
  initial_vector.x = -initial_vector.x
  var snowball = load("res://sandbox/snowball.tscn").instantiate()
  #var vector_to_target = (p_target.position - position)
  #var vector_to_target_normalized = (p_target.position - position).normalized()
  snowball.position = position + initial_vector * 3
  level.add_child(snowball)
  var target = shapecast.get_collider(0)
  var vector_to_target: Vector3
  var vector_to_target_length
  if target:
    vector_to_target = shapecast.get_collider(0).position - position
    vector_to_target_length = vector_to_target.length()
    vector_to_target = initial_vector * vector_to_target_length
  else:
    vector_to_target = initial_vector * 20
  snowball.apply_central_impulse(vector_to_target * 1.5 + Vector3(0, 13, 0))

func remove_from_game() -> void:
  $AnimationPlayer.play("hit")
  var timer = Timer.new()
  timer.connect("timeout", queue_free)
  add_child(timer)
  timer.start(1.5)
