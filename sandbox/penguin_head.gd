extends Node3D

@onready var area = $Area3D
# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  var bodies_inside = area.get_overlapping_bodies()
  for body in bodies_inside:
    if body is MainPlayerController and body.is_in_movement:
      get_parent().handle_minigame()
      get_parent().red_light_green_light_timer.stop()
