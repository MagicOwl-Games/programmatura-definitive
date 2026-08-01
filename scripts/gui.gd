extends Control

@onready var items_panel: Panel = $ItemsPanel;
@onready var restore_action_menu_button: Panel  = $ActionButtons/CloseButtonPanel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.item_menu_signal.connect(_on_gui_handle_item_menu_signal);
	TurnManager.is_moving_player_signal.connect(_on_gui_handle_is_moving_player_signal);
	items_panel.visible = false;
	restore_action_menu_button.visible = false;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gui_handle_item_menu_signal(is_opening: bool) -> void:
	items_panel.visible = is_opening;
	$ActionButtons/ItemButton.disabled = is_opening;
	$ActionButtons/MoveButton.disabled = is_opening;

func _on_gui_handle_is_moving_player_signal(is_moving: bool) -> void:
	restore_action_menu_button.visible = is_moving;
	$ActionButtons/ItemButton.disabled = is_moving;
	$ActionButtons/MoveButton.disabled = is_moving;	
	$ActionButtons.position.y = $ActionButtons.position.y + 140 if is_moving else $ActionButtons.position.y - 140;
	print('signal emmited');

func _on_move_button_pressed() -> void:
	TurnManager.is_moving_player_signal.emit(true);
	
func _on_item_button_pressed() -> void:
	GameState.item_menu_signal.emit(true);
	
func _on_close_items_panel_button_pressed() -> void:
	GameState.item_menu_signal.emit(false);

func _on_restore_action_menu_panel_button_pressed() -> void:
	TurnManager.is_moving_player_signal.emit(false);
