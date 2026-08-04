extends Node

# TODO: does it need a param? think about it
signal item_menu_signal(is_open: bool);
signal player_detected_signal;
# TODO: if the player has no movement to be done, should it be possible to
#pass the turn? Should the pass possibility be a consumable?
# TODO: if the player has no movement, but is not the detection range of the
#enemy? Maybe the pass should become a strategy, but this would require it to
#be an option, not a consumable, or the game might get stuck. OR it should be
#checked if the player has a pass item, and force the use to continue the run,
#otherwise it's game over. 

# TODO: write a safer type for items in general
var collectibles: Array[Item] = [];
var consumables: Array[Item] = [];
var player;

var is_item_menu_open: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#item_menu_signal.connect(_on_game_state_handle_item_menu_signal);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#func _on_game_state_handle_item_menu_signal(is_opening: bool) -> void:
	#is_item_menu_open = is_opening;
	##action_menu.position.y += 80;
	##items_menu.position.y += 80;
	#print(is_opening);

#func handle_menus_position(is_opening: bool, action_menu: Panel, items_menu: Panel) -> void:
	#action_menu.position.y += 80;
	#items_menu.position.y += 80;
