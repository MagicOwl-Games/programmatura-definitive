class_name Player
extends Character;

# RAYCASTS
@onready var up_raycast: RayCast2D = $MovementArea/UpRayCast2D;
@onready var down_raycast: RayCast2D = $MovementArea/DownRayCast2D;
@onready var left_raycast: RayCast2D = $MovementArea/LeftRayCast2D;
@onready var right_raycast: RayCast2D = $MovementArea/RightRayCast2D;

# MOVE BUTTONS
@onready var up_button: Button = $UI/UpButton;
@onready var down_button: Button = $UI/DownButton;
@onready var left_button: Button = $UI/LeftButton;
@onready var right_button: Button = $UI/RightButton;

# TODO:
# - the player can get power ups from items, such as double turn or a bigger
#range of movement for a few turns
# - some items will affect the enemies and the stage
var collectibles: Array[Item];
var consumables: Array[Item];
var collision_areas: Array[Area2D];


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
	
	up_button.visible = false;
	down_button.visible = false;
	left_button.visible = false;
	right_button.visible = false;
	
	#for child in self.get_children():
		#if child is Area2D:
			##child.hide();
			#collision_areas.append(child);
	
	
func _on_player_handle_is_moving_player_signal(is_moving: bool) -> void:
	#print("player signal handler activated: %s" % is_moving);
	handle_player_collision_check(is_moving);

func _on_move_button_pressed(node_path: String) -> void:
	var button: Button = get_node(node_path);
	var position_to_move: Vector2 = button.pivot_offset;
	position += position_to_move;
	TurnManager.is_moving_enemies_signal.emit();
	TurnManager.is_moving_player_signal.emit(false);

func handle_player_collision_check(is_moving: bool) -> void:
	if is_moving:
		up_raycast.force_raycast_update();
		down_raycast.force_raycast_update();
		left_raycast.force_raycast_update();
		right_raycast.force_raycast_update();
		
		# TODO: use tilesets' physics layer to try and check the collisions
		#with raycast. for now staticbody2d seems to be working
		print("up_raycast is colliding: %s" % up_raycast.is_colliding());
		print("up_raycast collider: %s" % up_raycast.get_collider());
		print("down_raycast is colliding: %s" % down_raycast.is_colliding());
		print("down_raycast collider: %s" % down_raycast.get_collider());
		print("left_raycast is colliding: %s" % left_raycast.is_colliding());
		print("left_raycast collider: %s" % left_raycast.get_collider());
		print("right_raycast is colliding: %s" % right_raycast.is_colliding());
		print("right_raycast collider: %s" % right_raycast.get_collider());
		
		up_button.visible = !up_raycast.is_colliding();
		down_button.visible = !down_raycast.is_colliding();
		left_button.visible = !left_raycast.is_colliding();
		right_button.visible = !right_raycast.is_colliding();
	else:
		up_button.visible = false;
		down_button.visible = false;
		left_button.visible = false;
		right_button.visible = false;
