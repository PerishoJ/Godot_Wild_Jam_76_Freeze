extends Node3D
class_name PenguinAnimCtrl

var penguin_action: String
var target_rotation
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_camera_rig_camera_rotation_event(rotation):
  # I really have no idea why it is rotated
  target_rotation=rotation
  
func _physics_process(delta):
  if target_rotation:
    rotation = target_rotation
