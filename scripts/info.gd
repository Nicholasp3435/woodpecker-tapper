@tool
extends Control;

@onready var game_manager: Node = %GameManager;

@onready var common_name: RichTextLabel = $General/CommonName
@onready var scientific_name: RichTextLabel = $General/ScientificName
@onready var brief: RichTextLabel = $General/Brief
@onready var iucn_color: ColorRect = $General/IUCNColor
@onready var iucn: RichTextLabel = $General/IUCN
@onready var icon: Sprite2D = $General/Icon

@onready var map: Sprite2D = $Distribution/Map


const WOODPECKER_IMAGE_PATH: String = "res://assets/sprites/woodpeckers/";
const DISTRIBUTION_IMAGE_MAP: String = "res://assets/sprites/maps/";

const IUCN_COLORS: Dictionary =  {"LC" = "#60c659", "NT" = "#cce227", "VU" = "#f9e814",
								  "EN" = "#fc7f3f", "CR" = "#da1c01", "EW" = "#542343",
								  "EX" = "#000000", "DD" = "#d1d1c4", "NE" = "#ffffff"};

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
	
	data = game_manager.WOODPECKER_DATA[taxon_code]
	
	icon.texture = load(WOODPECKER_IMAGE_PATH + taxon_code + ".png");
	map.texture = load(DISTRIBUTION_IMAGE_MAP + taxon_code + ".jpeg");
	
	common_name.text = data["name"];
	scientific_name.text = "[u][i]" + data["scientific"] + "[/i][/u]";
	brief.text = data["brief"];
	
	var iucn_cat: String = data["iucn"];
	iucn_color.color = IUCN_COLORS[iucn_cat];
	iucn.text = iucn_cat;


func _on_open_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		self.position.x -= 960;
	else:
		self.position.x += 960;
