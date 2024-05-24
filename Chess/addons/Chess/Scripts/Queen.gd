@tool
extends Pawn
class_name Queen

func _ready():
	self.texture = load("res://Chess/addons/Chess/Textures/WQueen.svg")

func _process(_delta):
	if Item_Color != Temp_Color:
		Temp_Color = Item_Color
		if Item_Color == 0:
			self.texture = load("res://Chess/addons/Chess/Textures/WQueen.svg")
		elif Item_Color == 1:
			self.texture = load("res://Chess/addons/Chess/Textures/BQueen.svg")
