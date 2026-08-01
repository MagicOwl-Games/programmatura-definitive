class_name Player
extends Character;

var collectibles: Array[Item];
var consumables: Array[Item];

func _init(
	p_character_name: String,
	p_collectibles: Array[Item] = [],
	p_consumables: Array[Item] = [],
) -> void:
	super(p_character_name, true);
	collectibles = p_collectibles;
	consumables = p_consumables;
	GameState.player = self;
