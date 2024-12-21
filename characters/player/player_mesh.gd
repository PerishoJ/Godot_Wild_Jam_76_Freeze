extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_camera_rig_camera_rotation_event(rotation):
  # Rotation the model to match the angle of the camera
  transform.basis = Basis( Vector3.UP, 1.0) * Basis(Vector3.UP,rotation.y + 90)
