extends CharacterBody2D

# TODO:
# - each enemy should have a fixed path to follow until the player is found
# - enemies should have different ranges of detection and different speed (move
#more or less squares)

@onready var detection_area: Node2D = $DetectionArea;

var collision_areas: Array;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_areas = detection_area.get_children();
	TurnManager.is_moving_enemies_signal.connect(_on_enemy_handle_is_moving_enemies_signal);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_handle_is_moving_enemies_signal(is_moving: bool) -> void:
	var free_areas: Array[Area2D] = [];
	
	if collision_areas.size() == 1:
		self.position += collision_areas[0].position;
		pass;
	
	for area in collision_areas:
		print("area is area2D: %s" % area is Area2D);
		print("area is overlapping_areas: %s" % area.has_overlapping_areas());
		if area is Area2D and not area.has_overlapping_areas():
			print("area info: %s" % area.name);
			free_areas.append(area);
	
	#prints("enemies moving: %s" % is_moving);
	
	var free_random: Area2D = free_areas.pick_random();
	self.position += free_random.position;
	
	#TurnManager.is_moving_enemies_signal.emit(false);
