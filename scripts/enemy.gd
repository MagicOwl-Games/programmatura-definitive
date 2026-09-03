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
@onready var detection_area_raycast: RayCast2D = $DetectionArea/RayCast2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D;

var current_enemy_x = 0;
var current_enemy_y = 0;
# var last_enemy_x = current_enemy_x;
# var last_enemy_y = current_enemy_y;
# var next_enemy_x = 1;
# var next_enemy_y = 1;
var move_direction = Move_Direction.RIGHT;

var detection_area_current_position: Move_Direction;

const TILE_SIZE = 64;


# FIXME: the way it is today, the enemy cannot be positioned in a way that moving one tile
#to the side will result in a collision with an obstacle.

# FIXME: still can't type it properly, try to figure out a way of defining its value
#without using get_children().
var collision_areas: Array;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_type = Enemy_Movement_Type.HORIZONTAL if movement_type == null else movement_type;
	# FIXME: WOW!!! SUCH GOOD CODE MUCH WOW
	#collision_areas = movement_area.get_children();
	#detection_area.hide();
	init_detection_area();
	TurnManager.is_moving_enemies_signal.connect(_on_enemy_handle_is_moving_enemies_signal);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_handle_is_moving_enemies_signal() -> void:
	update_raycasts();	
	handle_enemy_movement();


func handle_enemy_movement() -> void:
	# FIXME: the detection area rotation is weird
	# It's fine for now, but i'm gonna work on a better approach and improve the rotation later
	match movement_type:
		Enemy_Movement_Type.HORIZONTAL:
			if current_enemy_x == -1:
				move_direction = Move_Direction.RIGHT;
			if current_enemy_x == 1:
				move_direction = Move_Direction.LEFT;

			current_enemy_x += move_direction;
			
			var tween = create_tween();
			tween.tween_property(
				self,
				"position:x",
				move_direction * TILE_SIZE,
				1
			).as_relative();
			
			print(current_enemy_x);
			if current_enemy_x == Move_Direction.LEFT or current_enemy_x == Move_Direction.RIGHT:
				tween.tween_property(
					self,
					"rotation_degrees",
					180,
					1
				).as_relative();
				
		Enemy_Movement_Type.VERTICAL:
			if current_enemy_y == -1:
				move_direction = Move_Direction.DOWN;
			if current_enemy_y == 1:
				move_direction = Move_Direction.UP;

			current_enemy_y += move_direction;
			self.position.y += (move_direction * TILE_SIZE);
			
			if current_enemy_y == Move_Direction.UP or current_enemy_y == Move_Direction.DOWN:
				self.rotation_degrees += 180;
		Enemy_Movement_Type.L_SHAPED:
			pass;
		Enemy_Movement_Type.FOUR_WAY:
			pass;

	handle_enemy_detection();


func handle_enemy_detection() -> void:
	#update_raycasts();
	#detection_area_raycast.force_raycast_update();
	

	# FIXME: raycast detection is crazy, it looks late even though force_raycast_update
	#is called. gotta see it later
	match movement_type:
		Enemy_Movement_Type.HORIZONTAL:
			print("first detection area raycast is colliding %s" % detection_area_raycast.is_colliding());
			detection_area_raycast.force_raycast_update();
			#print("second detection area raycast is colliding %s" % detection_area_raycast.is_colliding());
			if detection_area_raycast.is_colliding():
				var collider = detection_area_raycast.get_collider();
				if collider.is_in_group("player"):
					print("player got caught!");
			# if right_raycast.is_colliding():
			# 	var collider = right_raycast.get_collider();
			# 	if collider.is_in_group("obstacles"):
			# 		self.rotation_degrees += 180;
			# 	if collider.is_in_group("player"):
			# 		print("player got caught!!");
			# 	return;
			#if current_enemy_x == Move_Direction.LEFT:
				#self.rotation_degrees += 180;
				#return;
			#if current_enemy_x == Move_Direction.RIGHT:
				#self.rotation_degrees += 180;
				#return;
		Enemy_Movement_Type.VERTICAL:
			pass;
			#if current_enemy_y == Move_Direction.DOWN:
				#self.rotation_degrees += 180;
				#return;
			#if current_enemy_y == Move_Direction.UP:
				#self.rotation_degrees += 180;
				#return;
	
# TODO: this logic should be a helper, it's duplicated
func init_detection_area() -> void:
	update_raycasts();
	detection_area_raycast.force_raycast_update();
	
	#var directions_array: Array[RayCast2D] = [
		#up_raycast,
		#down_raycast,
		#left_raycast,
		#right_raycast,
	#];
	#
	#var enemy_vision: RayCast2D = null;

	match movement_type:
		Enemy_Movement_Type.HORIZONTAL:
			# print("right_raycast is colliding: %s" % right_raycast.is_colliding());
			if not right_raycast.is_colliding():
				detection_area.position.x += (Move_Direction.RIGHT * TILE_SIZE);
				detection_area_current_position = Move_Direction.RIGHT;
			else:
				detection_area.position.x += (Move_Direction.LEFT * TILE_SIZE);
				detection_area_current_position = Move_Direction.LEFT;
		Enemy_Movement_Type.VERTICAL:
			if not down_raycast.is_colliding():
				detection_area.position.y += (Move_Direction.DOWN * TILE_SIZE);
				detection_area_current_position = Move_Direction.DOWN;
			else:
				detection_area.position.y += (Move_Direction.UP * TILE_SIZE);
				detection_area_current_position = Move_Direction.UP;
		Enemy_Movement_Type.L_SHAPED:
			pass;
		Enemy_Movement_Type.FOUR_WAY:
			pass;
	
	

# HELPERS
func update_raycasts():
	up_raycast.force_raycast_update();
	down_raycast.force_raycast_update();
	left_raycast.force_raycast_update();
	right_raycast.force_raycast_update();
