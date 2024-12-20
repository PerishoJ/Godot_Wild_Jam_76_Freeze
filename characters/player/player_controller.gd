extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5

# This is updated every frame to match what angle the camera is at compared to the object.
var _camera_rotation : Vector3 = Vector3( 0 , 0 , 0 )

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
  # Now rotate one more time to match the angle of the camera
  print("camera rotation is " + str(_camera_rotation))
  direction = direction.rotated(Vector3.UP, _camera_rotation.y)
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()


func _on_camera_rig_camera_rotation_event(rotation):
  _camera_rotation=rotation
  print(" Received " + str(rotation) + " and value is now " + str(_camera_rotation))
