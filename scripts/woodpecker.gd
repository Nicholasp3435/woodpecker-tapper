@tool
extends TextureButton

@onready var game_manager: Node = %GameManager;
@onready var pyre: Node2D = %Pyre;
@onready var label: Label = $Label;

const WOODPECKER_IMAGE_PATH: String = "res://assets/sprites/woodpeckers/";

## Macaulay Library taxon code
@export var taxon_code: String = "":
	set(value):
		taxon_code = value
		if is_node_ready():
			update_self()

var data: Dictionary = {};
var max_time: float = 0;

func _ready():
	update_self();

func update_self():
	if taxon_code == "":
		return;

	var image_path: String = WOODPECKER_IMAGE_PATH + taxon_code + ".png";
	texture_normal = load(image_path);
	
	data = game_manager.woodpecker_data[taxon_code]
	max_time = data["data"][-1]["timer"] / 1000;
	
	label.text = data["name"];

func _on_button_up() -> void:
	if pyre.cur_state != pyre.Drumming_States.IDLE:
		return;
		
	pyre.sample_timer.wait_time = max_time;
	pyre.sample_timer.start();
	game_manager.handle_pattern(data);
