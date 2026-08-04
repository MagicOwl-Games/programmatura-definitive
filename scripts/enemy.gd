extends CharacterBody2D

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
#while it shouldn't. It's better is the enemy finds another way to face, but checking
#the collision shapes after repositioning the enemy is not working.

@onready var movement_area: Node2D = $MovementArea;
@onready var detection_area: Node2D = $DetectionArea;

var collision_areas: Array;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_areas = movement_area.get_children();
	detection_area.hide();
	init_detection_area();
	TurnManager.is_moving_enemies_signal.connect(_on_enemy_handle_is_moving_enemies_signal);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_handle_is_moving_enemies_signal() -> void:
	var free_areas: Array[Area2D] = [];

	for area in collision_areas:
		#print("area is area2D: %s" % area is Area2D);
		#print("area is overlapping_areas: %s" % area.has_overlapping_areas());
		if area is Area2D and not area.has_overlapping_areas():
			#print("area info: %s" % area.name);
			free_areas.append(area);

	if free_areas.size() == 0:
		return;
	
	if free_areas.size() == 1:
		self.position += free_areas[0].position;
		detection_area.position = free_areas[0].position;
		return;
	
	var free_random: Area2D = free_areas.pick_random();
	print("%s before detection handling %s" % [self.name, self.position]);
	self.position += free_random.position;
	handle_detection_area();
	#detection_area.position = free_random.position;

	#TurnManager.is_moving_enemies_signal.emit(false);

func handle_detection_area() -> void:
	print("%s after detection handling %s" % [self.name, self.position]);
	var free_areas: Array[Area2D] = [];
	
	for area in collision_areas:
		if area is Area2D and not area.has_overlapping_areas():
			free_areas.append(area);
	
	if free_areas.size() == 0:
		return;
	
	if free_areas.size() == 1:
		detection_area.position += free_areas[0].position;
		detection_area.show();
		return;
	
	for area in free_areas:
		area.modulate = Color(20, 0, 0);
		
	var free_random: Area2D = free_areas.pick_random();
	detection_area.position = free_random.position;

# TODO: this logic should be a helper, it's duplicated
func init_detection_area() -> void:
	var free_areas: Array[Area2D] =  [];
	
	for area in collision_areas:
		if area is Area2D and not area.has_overlapping_areas():
			free_areas.append(area);
	
	if free_areas.size() == 0:
		return;
	
	if free_areas.size() == 1:
		detection_area.position += free_areas[0].position;
		detection_area.show();
		return;
	
	
	var free_random: Area2D = free_areas.pick_random();
	detection_area.position = free_random.position;
	detection_area.show();
