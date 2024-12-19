extends Button

var game_level: Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	game_level = get_tree().get_root().get_node("Test_Scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_down():
	var answer = get_parent().get_node("Answer").text
	if answer == "11":
		game_level.player.set_physics_process(true)
		get_parent().get_node("Result").text = "You got it correct!"
		
	else:
		game_level.player.set_physics_process(false)
		get_parent().get_node("Result").text = "Wrong"
	get_parent().get_node("Result").show()
	
	var timer = get_tree().create_timer(1)
	timer.connect("timeout", game_level.unfreeze)
