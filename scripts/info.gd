@tool
extends Control;

@onready var game_manager: Node = %GameManager;

@onready var common_name: RichTextLabel = $General/CommonName
@onready var scientific_name: RichTextLabel = $General/ScientificName
@onready var brief: RichTextLabel = $General/Brief
@onready var iucn_color: ColorRect = $General/IUCNColor
@onready var iucn: RichTextLabel = $General/IUCN
@onready var icon: Sprite2D = $General/Icon
@onready var border: Sprite2D = $General/Border

@onready var map: Sprite2D = $Distribution/Map

@onready var image_link: LinkButton = $Credits/ImageLink
@onready var drum_link: LinkButton = $Credits/DrumLink
@onready var drum_time: Label = $Credits/DrumTime

const WOODPECKER_IMAGE_PATH: String = "res://assets/sprites/woodpeckers/";
const DISTRIBUTION_IMAGE_MAP: String = "res://assets/sprites/maps/";
const MACAULAY_LABEL: String = "Macaulay Library #%s";

const IUCN_COLORS: Dictionary =  {
	"LC" = {"bg" = "#60c659", "fg" = 0 },
	"NT" = {"bg" = "#d1e744", "fg" = 0 }, 
	"VU" = {"bg" = "#e5d42d", "fg" = 0 },
	"EN" = {"bg" = "#e77b4d", "fg" = 0 }, 
	"CR" = {"bg" = "#b61917", "fg" = 1 }, 
	"EW" = {"bg" = "#542344", "fg" = 1 },
	"EX" = {"bg" = "#000000", "fg" = 1 }, 
	"DD" = {"bg" = "#595959", "fg" = 1 }, 
	"NE" = {"bg" = "#cccccc", "fg" = 0 }
};

## Macaulay Library taxon code
@export var taxon_code: String = "":
	set(value):
		taxon_code = value
		if is_node_ready():
			update_self();

var data: Dictionary = {};

func _ready():
	update_self();

func update_self():
	if taxon_code == "":
		return;
	
	data = game_manager.WOODPECKER_DATA[taxon_code]
	
	icon.texture = load(WOODPECKER_IMAGE_PATH + taxon_code + ".png");
	map.texture = load(DISTRIBUTION_IMAGE_MAP + taxon_code + ".jpg");
	
	if map.texture.get_width() - map.texture.get_height() >= 0:
		# horizontal / square
		map.scale = Vector2(1./3, 1./3);
	else:
		# vertical
		map.scale = Vector2(0.4, 0.4);
	
	common_name.text = data["name"];
	scientific_name.text = "[u][i]" + data["scientific"] + "[/i][/u]";
	brief.text = data["brief"];
	
	var iucn_cat: String = data["iucn"];
	iucn_color.color = IUCN_COLORS[iucn_cat]["bg"];
	
	iucn.text = iucn_cat;
	if IUCN_COLORS[iucn_cat]["fg"] == 0:
		iucn.add_theme_color_override("default_color", "#000000");
	else:
		iucn.add_theme_color_override("default_color", "#ffffff");
		
	image_link.uri = data["image-source"];
	if data["image-source"].contains("macaulaylibrary"):
		image_link.text = MACAULAY_LABEL % data["image-source"].split('/')[-1];
		
	drum_link.uri = data["drum-source"];
	if data["drum-source"].contains("macaulaylibrary"):
		drum_link.text = MACAULAY_LABEL % data["drum-source"].split('/')[-1];
		
	var minute: int = data["source-time"] / 60;
	var sec: int = (data["source-time"] as int) % 60;
	drum_time.text = "at %d:%02d" % [minute, sec]
	
