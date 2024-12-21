extends Node3D

signal camera_rotation_event (rotation)

@onready var gimble: Node3D = $Gimble
@onready var camera: Camera3D = $Gimble/Camera3D
@export var rotation_scale:float = 0.001


func _ready():
  # Hide the mouse, so we can use it for camera controls
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
  # Do nothing?! yes, do nothing at all
  pass


# Mouse movement is usually captured in unhandled input events.
# maybe there's a better way, but we did it this way today.		
func _unhandled_input(event: InputEvent) -> void:
  _make_the_camera_follow_mouse_movements(event)

# Rotate the camera when you move the mouse
func _make_the_camera_follow_mouse_movements(event: InputEvent) -> void:
  if(event is InputEventMouseMotion):
  # orbit the camera left and right around the basic location
    var motion = -(event as InputEventMouseMotion).relative.x
    rotate_y(motion* rotation_scale);
  # send an event to the player controller so that the "forward"
  # direction can be adjusted
    emit_signal("camera_rotation_event", rotation)
