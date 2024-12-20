extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area3D.connect("body_entered", _on_finished_line_crossed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_finished_line_crossed(p_body) -> void:
	if p_body.name == "Player":
		owner.succeeded_race()
