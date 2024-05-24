@tool
extends Pawn
class_name King

var Castling = true

func _ready():
	self.texture = load("res://Chess/addons/Chess/Textures/WKing.svg")

func _process(_delta):
	if Item_Color != Temp_Color:
		Temp_Color = Item_Color
		if Item_Color == 0:
			self.texture = load("res://Chess/addons/Chess/Textures/WKing.svg")
		elif Item_Color == 1:
			self.texture = load("res://Chess/addons/Chess/Textures/BKing.svg")
