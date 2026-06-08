@tool
extends Node

@onready var pyre: Node2D = %Pyre
@onready var counter_label: Label = $"../CounterLabel"
@onready var playing_label: Label = $"../PlayingLabel"

const WOODPECKER_DATA: Dictionary = preload("res://assets/woodpecker_data.json").data;

var in_recording_mode: bool = false;

enum Game_States {TIMER, ENDLESS};
var cur_state: int = Game_States.TIMER;
