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

func _ready():
	update_self();


func update_self():
	if taxon_code == "":
		return;

	var image_path: String = WOODPECKER_IMAGE_PATH + taxon_code + ".png";
	texture_normal = load(image_path);
	
	data = game_manager.WOODPECKER_DATA[taxon_code]
	
	label.text = data["name"];


func _on_button_up() -> void:
	if pyre.cur_state != pyre.Drumming_States.IDLE:
		return;
		
	pyre.handle_pattern(data);
