extends CharacterBody2D

var positions: Dictionary[String, Vector2] = {
	"up": Vector2(0, -64),
	"down": Vector2(0, 64),
	"left": Vector2(-64, 0),
	"right": Vector2(64, 0),
}

enum Enemy_Movement_Type {
	HORIZONTAL,			# Move left to right, right to left
	VERTICAL,			# Move up to down, down to up
	L_SHAPED,			# one up/down, one left/right
	FOUR_WAY			# one time in each direction
};

@export var movement_type: Enemy_Movement_Type;
# TODO:
# - each enemy should have a fixed path to follow until the player is found
#	- i though about using areas to check the movement of the enemies, but
#it probably wont work well. i should find a pathfinding alternativa and should
#check the position of the detection span — if there is something blocking the way,
#the detection should be less, non-existent at all or even pointed the a different side
# - enemies should have different ranges of detection and different speed (move
#more or less squares)
# TODO:
# - the detection area can be turned to a blocked space (walls and obstacles),
#while it shouldn't. The enemy should find another way to face, but checking
#the collision shapes after repositioning the enemy is not working.
# TODO:
# - has_overlapping_areas collides with any area, so it is conflicting with the
#detection areas of other enemies. check if the colliding object is a wall or
#obstacles

enum Directions {
	UP, DOWN, LEFT, RIGHT
};

enum Move_Direction {
	LEFT = -1,
	RIGHT = 1,
	DOWN = 1,
	UP = -1
}

@onready var up_raycast: RayCast2D = $MovementArea/UpRayCast2D;
@onready var down_raycast: RayCast2D = $MovementArea/DownRayCast2D;
@onready var left_raycast: RayCast2D = $MovementArea/LeftRayCast2D;
@onready var right_raycast: RayCast2D = $MovementArea/RightRayCast2D;
@onready var detection_area: Sprite2D = $DetectionArea;

var current_enemy_x = 0;
var current_enemy_y = 0;
var last_enemy_x = current_enemy_x;
var last_enemy_y = current_enemy_y;
var next_enemy_x = 1;
var next_enemy_y = 1;
var move_direction = Move_Direction.RIGHT;

const TILE_SIZE = 64;



# FIX: still can't type it properly, try to figure out a way of defining its value
#without using get_children().
var collision_areas: Array;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_type = Enemy_Movement_Type.HORIZONTAL if movement_type == null else movement_type;
	# FIX: WOW!!! SUCH GOOD CODE MUCH WOW
	#collision_areas = movement_area.get_children();
	#detection_area.hide();
	init_detection_area();
	TurnManager.is_moving_enemies_signal.connect(_on_enemy_handle_is_moving_enemies_signal);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_handle_is_moving_enemies_signal() -> void:
	update_raycasts();
	
	#var directions_array: Array[RayCast2D] = [
		#up_raycast,
		#down_raycast,
		#left_raycast,
		#right_raycast,
	#];
	
	handle_enemy_movement();
	
	#var direction_to_move: RayCast2D = null;
	#var direction_to_detect: RayCast2D = null;
	
	# FIX: this loop is breaking the game, here and down below
	# it was breaking because at some point the directions_array was full of null
	#values, so I had to move it inside the function to make it work.
	#while direction_to_move == null:
		#var random_direction: Directions = Directions.values().pick_random();
		#if not directions_array[random_direction].is_colliding():
			#direction_to_move = directions_array[random_direction];
	#
	#match direction_to_move:
		#up_raycast:
			#position += positions.up;
		#down_raycast:
			#position += positions.down;
		#left_raycast:
			#position += positions.left;
		#right_raycast:
			#position += positions.right;
			#
	## updating raycasts again because i'm positioning the detection area now
	## is it necessary? is it necessary to use the raycasts at all?
	#update_raycasts();
	
	
	
	#if direction_to_move.is_colliding():
		#match direction_to_move:
			#up_raycast:
				#detection_area.position = positions.down;
			#down_raycast:
				#detection_area.position = positions.up;
			#left_raycast:
				#detection_area.position = positions.right;
			#right_raycast:
				#detection_area.position = positions.left;
	#else:
		#detection_area.position = direction_to_move.position;
	#if direction_to_move.is_colliding():
		#while direction_to_detect == null:
			#var random_direction: Directions = Directions.values().pick_random();
			#if not directions_array[random_direction].is_colliding():
				#direction_to_detect = directions_array[random_direction];
	
	#match direction_to_move:
		#up_raycast:
			#detection_area.position = Vector2(0, -64);
		#down_raycast:
			#detection_area.position = Vector2(0, 64);
		#left_raycast:
			#detection_area.position = Vector2(-64, 0);
		#right_raycast:
			#detection_area.position = Vector2(64, 0);


func handle_enemy_movement() -> void:
	# FIX: still don't know how to handle this movement, gotta check it soon
	

	match movement_type:
		Enemy_Movement_Type.HORIZONTAL:
			if current_enemy_x == 1:
				move_direction = Move_Direction.LEFT;
			if current_enemy_x == -1:
				move_direction = Move_Direction.RIGHT;

			current_enemy_x += move_direction;
			self.position.x += (move_direction * TILE_SIZE);
		Enemy_Movement_Type.VERTICAL:
			print("enemy2 move direction is %s" % move_direction);
			if current_enemy_y == -1:
				move_direction = Move_Direction.DOWN;
			if current_enemy_y == 1:
				move_direction = Move_Direction.UP;

			current_enemy_y += move_direction;
			self.position.y += (move_direction * TILE_SIZE);
		Enemy_Movement_Type.L_SHAPED:
			pass;
		Enemy_Movement_Type.FOUR_WAY:
			pass;

	
# TODO: this logic should be a helper, it's duplicated
func init_detection_area() -> void:
	update_raycasts();
	
	var directions_array: Array[RayCast2D] = [
		up_raycast,
		down_raycast,
		left_raycast,
		right_raycast,
	];
	
	var enemy_vision: RayCast2D = null;
	
	while enemy_vision == null:
		var random_direction = Directions.values().pick_random();
		if not directions_array[random_direction].is_colliding():
			enemy_vision = directions_array[random_direction];

	match enemy_vision:
		up_raycast:
			detection_area.position += positions.up;
		down_raycast:
			detection_area.position += positions.down;
		left_raycast:
			detection_area.position += positions.left;
		right_raycast:
			detection_area.position += positions.right;
	
	

# HELPERS
func update_raycasts():
	up_raycast.force_raycast_update();
	down_raycast.force_raycast_update();
	left_raycast.force_raycast_update();
	right_raycast.force_raycast_update();
