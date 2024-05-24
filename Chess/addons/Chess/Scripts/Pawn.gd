@tool
extends Sprite2D
class_name Pawn

@export var Current_X_Position = 0
@export var Current_Y_Position = 0

# Item_Color = 0; White
# Item_Color = 1; Black
@export var Item_Color = 0
var Temp_Color = 0

var Double_Start = true
var En_Passant = false

func _ready():
	self.texture = load("res://Chess/addons/Chess/Textures/WPawn.svg")

func _process(_delta):
	if Item_Color != Temp_Color:
		Temp_Color = Item_Color
		if Item_Color == 0:
			self.texture = load("res://Chess/addons/Chess/Textures/WPawn.svg")
		elif Item_Color == 1:
			self.texture = load("res://Chess/addons/Chess/Textures/BPawn.svg")

