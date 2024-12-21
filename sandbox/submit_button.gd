extends Button

var game_level: Node3D
var quizz_minigame
@onready var parent = get_parent()
@onready var question = get_parent().get_node("Question")
@onready var answer = get_parent().get_node("Answer")
@onready var result = get_parent().get_node("Result")

# Called when the node enters the scene tree for the first time.
func _ready():
  game_level = get_tree().get_root().get_node("RootNode/Test_Scene")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _on_button_down():
  if text == quizz_minigame.question_picked["answer"]:
    game_level.player.set_physics_process(true)
    result.text = "You got it correct!"
    
  else:
    Globals.minigame_succeeded = false
    game_level.apply_minigame_result()
    result.text = "Wrong"
  result.show()
  
  var timer = get_tree().create_timer(1)
  timer.connect("timeout", game_level.unfreeze.bind(owner))
