extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass




func _on_Snowball_body_entered(body):
  if body.name != "GridMap":
    body.remove_from_game()


func _on_timer_timeout():
  queue_free()
