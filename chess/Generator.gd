extends FlowContainer

var scene_switcher: Node

@export var Board_X_Size = 8
@export var Board_Y_Size = 8

@export var Tile_X_Size: int = 50
@export var Tile_Y_Size: int = 50

signal send_location

func _ready():

	scene_switcher = $/root/chess/BoardSceneSwitcher

	# stop negative numbers from happening
	if Board_X_Size < 0 || Board_Y_Size < 0:
		return
	var Number_X = 0
	var Number_Y = 0
	# Set up the board
	while Number_Y != Board_Y_Size:
		self.size.y += Tile_Y_Size + 5
		self.size.x += Tile_X_Size + 5
		while Number_X != Board_X_Size:
			var temp = Button.new()
			temp.set_custom_minimum_size(Vector2(Tile_X_Size, Tile_Y_Size))
			temp.connect("pressed", func():
				emit_signal("send_location", temp.name))
			temp.set_name(str(Number_X) + "-" + str(Number_Y))
			add_child(temp)
			Number_X += 1
		Number_Y += 1
		Number_X = 0
	Regular_Game()

func switch_to_next_scene() -> void:
	var next_scene_path: String = "res://Stages/Test Stage.tscn"
	scene_switcher.SwitchScene(next_scene_path);
	
func _process(float)->void:
	if Input.is_action_pressed("change_scene"):
		switch_to_next_scene()

func Regular_Game():
	get_node("0-0").add_child(Summon("Rook", 1))
	get_node("1-0").add_child(Summon("Knight", 1))
	get_node("2-0").add_child(Summon("Bishop", 1))
	get_node("3-0").add_child(Summon("Queen", 1))
	get_node("4-0").add_child(Summon("King", 1))
	get_node("5-0").add_child(Summon("Bishop", 1))
	get_node("6-0").add_child(Summon("Knight", 1))
	get_node("7-0").add_child(Summon("Rook", 1))
	
	get_node("0-1").add_child(Summon("Pawn", 1))
	get_node("1-1").add_child(Summon("Pawn", 1))
	get_node("2-1").add_child(Summon("Pawn", 1))
	get_node("3-1").add_child(Summon("Pawn", 1))
	get_node("4-1").add_child(Summon("Pawn", 1))
	get_node("5-1").add_child(Summon("Pawn", 1))
	get_node("6-1").add_child(Summon("Pawn", 1))
	get_node("7-1").add_child(Summon("Pawn", 1))
	
	get_node("0-7").add_child(Summon("Rook", 0))
	get_node("1-7").add_child(Summon("Knight", 0))
	get_node("2-7").add_child(Summon("Bishop", 0))
	get_node("3-7").add_child(Summon("Queen", 0))
	get_node("4-7").add_child(Summon("King", 0))
	get_node("5-7").add_child(Summon("Bishop", 0))
	get_node("6-7").add_child(Summon("Knight", 0))
	get_node("7-7").add_child(Summon("Rook", 0))
	
	get_node("0-6").add_child(Summon("Pawn", 0))
	get_node("1-6").add_child(Summon("Pawn", 0))
	get_node("2-6").add_child(Summon("Pawn", 0))
	get_node("3-6").add_child(Summon("Pawn", 0))
	get_node("4-6").add_child(Summon("Pawn", 0))
	get_node("5-6").add_child(Summon("Pawn", 0))
	get_node("6-6").add_child(Summon("Pawn", 0))
	get_node("7-6").add_child(Summon("Pawn", 0))

func Summon(Piece_Name: String, color: int):
	var Piece
	match Piece_Name:
		"Pawn":
			Piece = Pawn.new()
			Piece.name = "Pawn"
		"King":
			Piece = King.new()
			Piece.name = "King"
		"Queen":
			Piece = Queen.new()
			Piece.name = "Queen"
		"Knight":
			Piece = Knight.new()
			Piece.name = "Knight"
		"Rook":
			Piece = Rook.new()
			Piece.name = "Rook"
		"Bishop":
			Piece = Bishop.new()
			Piece.name = "Bishop"
	Piece.Item_Color = color
	Piece.position = Vector2(Tile_X_Size / 2, Tile_Y_Size / 2)
	return Piece
