class_name Player
extends Character;

var collectibles: Array[Item];
var consumables: Array[Item];
var raycasts: Array[RayCast2D];

# TODO: is it gonna be initialized with "new()" somewhere? who knows
func _init(
	p_character_name: String = "Dummy",
	p_collectibles: Array[Item] = [],
	p_consumables: Array[Item] = [],
) -> void:
	super(p_character_name, true);
	collectibles = p_collectibles;
	consumables = p_consumables;
	GameState.player = self;
	
func _ready() -> void:
	TurnManager.is_moving_player_signal.connect(_on_player_handle_is_moving_player_signal);
	for child in self.get_children():
		if child is RayCast2D:
			child.visible = false;
			raycasts.append(child);
	
	
func _on_player_handle_is_moving_player_signal(is_moving: bool) -> void:
	print("player signal handler activated: %s" % is_moving);
	handle_player_collision_check(is_moving);

func handle_player_collision_check(is_moving: bool) -> void:
	for raycast in raycasts:
		if not raycast.is_colliding():
			raycast.visible = is_moving;
