class_name Item
extends Node

var item_id: int = 0;	# different from index in the item array
var is_selected: bool = false;
var is_consumable: bool = false;
var item_name: String;
var item_quantity: int;

func _init(
	p_name: String,
	p_quantity: int = 1,
	p_is_selected: bool = false,
	p_is_consumable: bool = false
) -> void:
	is_selected = p_is_selected;
	is_consumable = p_is_consumable;
	item_name = p_name;
	item_quantity = p_quantity;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# TODO: create helper script later, probably
func createItem(i_name: String, quantity: int = 1,
	selected: bool = false,
	consumable: bool = false) -> Item:
	var item: Item = Item.new(i_name, quantity, selected, consumable);
	return item;
