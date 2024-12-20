extends RigidBody3D

const SPEED = 1.0
const JUMP_VELOCITY = 4.5
var camera_rotation : Vector3 = Vector3( 0 , 0 , 0 )

func _process(delta: float) -> void:
	if_the_player_wants_to_quite()
	print(position)
	print(rotation_degrees)
	
func _physics_process(delta):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	# Rotate to match the input
	var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	# Now rotate one more time to match the angle of the camera
	# TODO How do we rotate this direction vector ( of x and z coords) , by our perpendicular Y angle???
	# With a basis object, of course, but I can't remember that API tonight, so this is a tomorrow thing
	var final_movement: Vector3
	if direction:
		final_movement = direction * SPEED
	else:
		final_movement.x = move_toward(direction.x, 0, SPEED)

	apply_central_impulse(final_movement)

func if_the_player_wants_to_quite():
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
