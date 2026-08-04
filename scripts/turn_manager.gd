extends Node

signal is_player_turn_now;
signal is_moving_player_signal(is_moving: bool);
signal is_moving_enemies_signal;

var turn_queue: Array = [];
var current_turn_index: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("turn manager running");
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
