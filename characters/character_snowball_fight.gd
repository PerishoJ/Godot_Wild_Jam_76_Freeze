extends CharacterBody3D


const SPEED = 5.0
var target: CharacterBody3D
@onready var level: Node3D = get_parent()
@onready var area = $Area3D
@onready var reload_timer = $ReloadTimer

func _ready():
	randomize()

func _physics_process(delta):
	var at_distance_enemies_array = area.get_overlapping_bodies()
	if at_distance_enemies_array:
		pass
		target = at_distance_enemies_array[randi() % at_distance_enemies_array.size()]
		launch_snowball(target)
			
	move_and_slide()



func launch_snowball(p_target) -> void:
	var snowball = load("res://sandbox/snowball.tscn").instantiate()
	var vector_to_target = (p_target.position - position)
	var vector_to_target_normalized = (p_target.position - position).normalized()
	snowball.position = position + vector_to_target_normalized * 3
	level.add_child(snowball)
	snowball.apply_central_impulse(vector_to_target * 1.2 + Vector3(0, 13, 0))

func remove_from_game() -> void:
	$AnimationPlayer.play("hit")
	var timer = Timer.new()
	timer.connect("timeout", queue_free)
	add_child(timer)
	timer.start(1.5)
