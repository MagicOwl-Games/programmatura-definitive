class_name Player
extends Character;

var collectibles: Array[Item];
var consumables: Array[Item];
var collision_free_areas: Array[Area2D];

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
		if child is Area2D:
			child.visible = false;
			collision_free_areas.append(child);
	
	
func _on_player_handle_is_moving_player_signal(is_moving: bool) -> void:
	print("player signal handler activated: %s" % is_moving);
	handle_player_collision_check(is_moving);

func _on_move_button_pressed(node_path: String) -> void:
	var button: Area2D = get_node(node_path);
	var position_to_move: Vector2 = button.position;
	position += position_to_move;
	TurnManager.is_moving_enemies_signal.emit(true);
	TurnManager.is_moving_player_signal.emit(false);

func handle_player_collision_check(is_moving: bool) -> void:
	for area in collision_free_areas:
		if not area.has_overlapping_areas():
			area.visible = is_moving;
