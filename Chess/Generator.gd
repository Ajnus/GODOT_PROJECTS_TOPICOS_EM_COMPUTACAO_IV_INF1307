extends FlowContainer

@export var Board_X_Size = 8
@export var Board_Y_Size = 8

@export var Tile_X_Size: int = 70
@export var Tile_Y_Size: int = 70

@export var background_texture: Texture

var board_size = Vector2(Board_X_Size*Tile_X_Size, Board_Y_Size*Tile_Y_Size)

signal send_location

func _ready():
	#centralize_board()

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
	

func Regular_Game():
	print("Regular Game")
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

"""
func save():
	var save_data = {
		"Board_X_Size": Board_X_Size,
		"Board_Y_Size": Board_Y_Size,
		"Tile_X_Size": Tile_X_Size,
		"Tile_Y_Size": Tile_Y_Size,
		"children": []
	}
	for child in get_children():
		var child_data = {}
		child_data["name"] = child.name
		child_data["position"] = child.position
		child_data["Item_Color"] = child.Item_Color
		save_data["children"].append(child_data)
		
	#FileAccess file = FileAccess.Open(save_path, FileAccess.ModeFlags.Write);
		#file.StoreVar(player_data);
		#GD.Print("global_position salva!");

		#file.Close();
"""

func centralize_board():
	#var flow = get_node("Flow")
	#if flow:
		
	# Obtém o tamanho da janela
	var window_size = Vector2(get_viewport().size)

	# Calcula a nova posição para centralizar o tabuleiro
	var new_position = (window_size - board_size) / 2
	
	# Define a nova posição
	self.rect_position = new_position

"""
func add_background():
	# Adicionar o TextureRect como fundo
	var background = TextureRect.new()
	background.texture = background_texture
	background.rect_min_size = board_size
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.z_index = -1  # Certifique-se de que o fundo fique atrás dos outros nós
	add_child(background)
"""
