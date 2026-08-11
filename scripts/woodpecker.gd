@tool
extends Control

@onready var game_manager: Node = %GameManager;
@onready var pyre: Node2D = %Pyre;
@onready var label: Label = $Label;
@onready var texture_button: TextureButton = $TextureButton


const WOODPECKER_IMAGE_PATH: String = "res://assets/sprites/woodpeckers/";
const WOODPECKER_DRUM_PATH: String = "res://assets/drum-data/";

## Macaulay Library taxon code
@export var taxon_code: String = "":
	set(value):
		taxon_code = value
		if is_node_ready():
			update_self()

var woopecker_data: Dictionary = {};
var drum_data: Array = [];


func _ready():
	update_self();


func update_self():
	if taxon_code == "":
		return;

	texture_button.texture_normal = load(WOODPECKER_IMAGE_PATH + taxon_code + ".png");	
	woopecker_data = game_manager.WOODPECKER_DATA[taxon_code];
	drum_data = load(WOODPECKER_DRUM_PATH + "/%s.json" % [taxon_code]).data;

	label.text = woopecker_data["name"].replace("-", "-" + char(0x200B));


func _on_button_up() -> void:
	if pyre.cur_state != pyre.Drumming_States.IDLE:
		return;
	
	game_manager.info.taxon_code = self.taxon_code;
	pyre.handle_pattern(woopecker_data, drum_data);
