extends Node3D

@onready var area = $Area3D
# Called when the node enters the scene tree for the first time.
func _ready():
  area.connect("body_entered", _on_Area3D_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func _on_Area3D_body_entered(p_body) -> void:
  if p_body.name == "Player":
    var timer = Timer.new()
    timer.connect("timeout", get_tree().change_scene_to_file.bind("res://sandbox/Win_screen.tscn"))
    add_child(timer)
    timer.start(0.8)
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
