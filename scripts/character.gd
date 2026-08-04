class_name Character
extends CharacterBody2D

var character_name: String;
var is_player: bool;
var character_id: int = 0;

func _init(c_name: String, c_is_player: bool =  true) -> void:
	character_name = c_name;
	is_player = c_is_player;
	character_id = get_instance_id();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
