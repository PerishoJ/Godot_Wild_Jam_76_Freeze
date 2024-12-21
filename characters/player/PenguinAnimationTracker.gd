extends AnimationTree

const PLAYER_ACTIONS = preload("res://characters/player/penguin_animation_actions.gd").PlayerAction

var state : PLAYER_ACTIONS = PLAYER_ACTIONS.IDLE;

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass
