extends Node

#var scene_switcher: Board
#var scene_switcher := BoardSceneSwitcher.new()
#var scene_switcher := null
#onready var scene_switcher = null

var Selected_Node = ""
var Turn = 0

var Location_X = ""
var Location_Y = ""

var pos = Vector2(35, 35)
var Areas: PackedStringArray
# this is seperate the Areas for special circumstances, like castling.
var Special_Area: PackedStringArray

var save_path = "res://BoardStats.sav";

var board_data = {};

func switch_to_next_scene() -> void:
	save_board_state()
	get_tree().change_scene_to_file("res://Stages/TestStage.tscn");

func _ready() -> void:
	var global = get_node("/root/Global")
	var flow_node = get_node("Flow")
	#print(flow_node.Name)
	
	#print("global.isInitializedBoard: ", global.isInitializedBoard)

	# continuando partida
	if global.isInitializedBoard == true && global.isActuallyInitializedBoard == true:
		print("TRUE TRUE")
		flow_node.Regular_Game()
		load_board_state()
		

	# escondido atrás da TestScene
	elif global.isInitializedBoard == false && global.isActuallyInitializedBoard == false:
		print("FALSE FALSE")
		global.isInitializedBoard = true;

	# nova partida
	elif global.isInitializedBoard == true && global.isActuallyInitializedBoard == false:
		print("TRUE FALSE")
		flow_node.Regular_Game()
		global.isActuallyInitializedBoard = true;

	
func _process(float) -> void:
	if Input.is_action_just_pressed("change_scene"):
		switch_to_next_scene()

func _on_flow_send_location(location: String):
	# variables for later
	var number = 0
	Location_X = ""
	var node = get_node("Flow/"+ location)
	# This is to try and grab the X and Y coordinates from the board
	while location.substr(number, 1) != "-":
		Location_X += location.substr(number, 1)
		number += 1
	Location_Y = location.substr(number + 1)
	# Now... we need to figure out how to select the pieces. If there is a valid move, do stuff.
	# If we re-select, just go to that other piece
	if Selected_Node == ""&&node.get_child_count() != 0&&node.get_child(0).Item_Color == Turn:
		Selected_Node = location
		Get_Moveable_Areas()
	elif Selected_Node != ""&&node.get_child_count() != 0&&node.get_child(0).Item_Color == Turn&&node.get_child(0).name == "Rook":
		# Castling
		for i in Areas:
			if i == node.name:
				var king = get_node("Flow/"+ Selected_Node).get_child(0)
				var rook = node.get_child(0)
				# Using a seperate array because Areas wouldn't be really consistant...
				king.reparent(get_node("Flow/"+ Special_Area[1]))
				rook.reparent(get_node("Flow/"+ Special_Area[0]))
				king.position = pos
				rook.position = pos
				# We have to get the parent because it will break lmao.
				Update_Game(king.get_parent())
	# En Passant
	elif Selected_Node != ""&&node.get_child_count() != 0&&node.get_child(0).Item_Color != Turn&&node.get_child(0).name == "Pawn"&&Special_Area.size() != 0&&Special_Area[0] == node.name&&node.get_child(0).get("En_Passant") == true:
		for i in Special_Area:
			if i == node.name:
				var pawn = get_node("Flow/"+ Selected_Node).get_child(0)
				node.get_child(0).free()
				pawn.reparent(get_node("Flow/"+ Special_Area[1]))
				pawn.position = pos
				Update_Game(pawn.get_parent())
	elif Selected_Node != ""&&node.get_child_count() != 0&&node.get_child(0).Item_Color == Turn:
		# Re-select
		Selected_Node = location
		Get_Moveable_Areas()
	elif Selected_Node != ""&&node.get_child_count() != 0&&node.get_child(0).Item_Color != Turn:
		# Taking over a piece
		for i in Areas:
			if i == node.name:
				var Piece = get_node("Flow/"+ Selected_Node).get_child(0)
				# Win conditions
				if node.get_child(0).name == "King":
					print("Damn, you win!")
				node.get_child(0).free()
				Piece.reparent(node)
				Piece.position = pos
				Update_Game(node)
	elif Selected_Node != ""&&node.get_child_count() == 0:
		# Moving a piece
		for i in Areas:
			if i == node.name:
				var Piece = get_node("Flow/"+ Selected_Node).get_child(0)
				Piece.reparent(node)
				Piece.position = pos
				Update_Game(node)

func Update_Game(node):
	Selected_Node = ""
	if Turn == 0:
		Turn = 1
	else:
		Turn = 0
	
	# get the en-passantable pieces and undo them
	var things = get_node("Flow").get_children()
	for i in things:
		if i.get_child_count() != 0&&i.get_child(0).name == "Pawn"&&i.get_child(0).Item_Color == Turn&&i.get_child(0).En_Passant == true:
			i.get_child(0).set("En_Passant", false)
	
	# Remove the abilities once they are either used or not used
	if node.get_child(0).name == "Pawn":
		if node.get_child(0).Double_Start == true:
			node.get_child(0).En_Passant = true
		node.get_child(0).Double_Start = false
	if node.get_child(0).name == "King":
		node.get_child(0).Castling = false
	if node.get_child(0).name == "Rook":
		node.get_child(0).Castling = false

# Below is the movement that is used for the pieces
func Get_Moveable_Areas():
	var Flow = get_node("Flow")
	# Clearing the arrays
	Areas.clear()
	Special_Area.clear()
	var Piece = get_node("Flow/"+ Selected_Node).get_child(0)
	# For the selected piece that we have, we can get the movement that we need here.
	if Piece.name == "Pawn":
		Get_Pawn(Piece, Flow)
	elif Piece.name == "Bishop":
		Get_Diagonals(Flow)
	elif Piece.name == "King":
		Get_Around(Piece)
	elif Piece.name == "Queen":
		Get_Diagonals(Flow)
		Get_Rows(Flow)
	elif Piece.name == "Rook":
		Get_Rows(Flow)
	elif Piece.name == "Knight":
		Get_Horse()

func Get_Pawn(Piece, Flow):
	# This is for going from the bottom to the top, also known as the white pawns.
	if Piece.Item_Color == 0:
		if not Is_Null(Location_X + "-" + str(int(Location_Y) - 1))&&Flow.get_node(Location_X +"-"+ str(int(Location_Y) - 1)).get_child_count() == 0:
			Areas.append(Location_X + "-" + str(int(Location_Y) - 1))
		if not Is_Null(Location_X + "-" + str(int(Location_Y) - 2))&&Piece.Double_Start == true&&Flow.get_node(Location_X +"-"+ str(int(Location_Y) - 2)).get_child_count() == 0:
			Areas.append(Location_X + "-" + str(int(Location_Y) - 2))
		# Attacking squares
		if not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1))&&Flow.get_node(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1)).get_child_count() == 1:
			Areas.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1))
		if not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1))&&Flow.get_node(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1)).get_child_count() == 1:
			Areas.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1))
		# En passant
		if not Is_Null(str(int(Location_X) - 1) + "-" + Location_Y)&& not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1)):
			if Flow.get_node(str(int(Location_X) - 1) + "-" + Location_Y).get_child_count() == 1&&Flow.get_node(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1)).get_child_count() != 1:
				Special_Area.append(str(int(Location_X) - 1) + "-" + Location_Y)
				Special_Area.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1))
		if not Is_Null(str(int(Location_X) + 1) + "-" + Location_Y)&& not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1)):
			if Flow.get_node(str(int(Location_X) + 1) + "-" + Location_Y).get_child_count() == 1&&Flow.get_node(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1)).get_child_count() != 1:
				Special_Area.append(str(int(Location_X) + 1) + "-" + Location_Y)
				Special_Area.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1))
	# Black pawns
	else:
		if not Is_Null(Location_X + "-" + str(int(Location_Y) + 1))&&Flow.get_node(Location_X +"-"+ str(int(Location_Y) + 1)).get_child_count() == 0:
			Areas.append(Location_X + "-" + str(int(Location_Y) + 1))
		if not Is_Null(Location_X + "-" + str(int(Location_Y) + 2))&&Piece.Double_Start == true&&Flow.get_node(Location_X +"-"+ str(int(Location_Y) + 2)).get_child_count() == 0:
			Areas.append(Location_X + "-" + str(int(Location_Y) + 2))
		# Attacking squares
		if not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1))&&Flow.get_node(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1)).get_child_count() == 1:
			Areas.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1))
		if not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1))&&Flow.get_node(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1)).get_child_count() == 1:
			Areas.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1))
		if not Is_Null(str(int(Location_X) - 1) + "-" + Location_Y)&& not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1)):
			if Flow.get_node(str(int(Location_X) - 1) + "-" + Location_Y).get_child_count() == 1&&Flow.get_node(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1)).get_child_count() != 1:
				Special_Area.append(str(int(Location_X) - 1) + "-" + Location_Y)
				Special_Area.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1))
		if not Is_Null(str(int(Location_X) + 1) + "-" + Location_Y)&& not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1)):
			if Flow.get_node(str(int(Location_X) + 1) + "-" + Location_Y).get_child_count() == 1&&Flow.get_node(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1)).get_child_count() != 1:
				Special_Area.append(str(int(Location_X) + 1) + "-" + Location_Y)
				Special_Area.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1))

func Get_Around(Piece):
	# Single Rows
	if not Is_Null(Location_X + "-" + str(int(Location_Y) + 1)):
		Areas.append(Location_X + "-" + str(int(Location_Y) + 1))
	if not Is_Null(Location_X + "-" + str(int(Location_Y) - 1)):
		Areas.append(Location_X + "-" + str(int(Location_Y) - 1))
	if not Is_Null(str(int(Location_X) + 1) + "-" + Location_Y):
		Areas.append(str(int(Location_X) + 1) + "-" + Location_Y)
	if not Is_Null(str(int(Location_X) - 1) + "-" + Location_Y):
		Areas.append(str(int(Location_X) - 1) + "-" + Location_Y)
	# Diagonal
	if not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1)):
		Areas.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) + 1))
	if not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1)):
		Areas.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) + 1))
	if not Is_Null(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1)):
		Areas.append(str(int(Location_X) + 1) + "-" + str(int(Location_Y) - 1))
	if not Is_Null(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1)):
		Areas.append(str(int(Location_X) - 1) + "-" + str(int(Location_Y) - 1))
	# Castling, if that is the case
	if Piece.Castling == true:
		Castle()

func Get_Rows(Flow):
	var Add_X = 1
	# Getting the horizontal rows first.
	while not Is_Null(str(int(Location_X) + Add_X) + "-" + Location_Y):
		Areas.append(str(int(Location_X) + Add_X) + "-" + Location_Y)
		if Flow.get_node(str(int(Location_X) + Add_X) + "-" + Location_Y).get_child_count() != 0:
			break
		Add_X += 1
	Add_X = 1
	while not Is_Null(str(int(Location_X) - Add_X) + "-" + Location_Y):
		Areas.append(str(int(Location_X) - Add_X) + "-" + Location_Y)
		if Flow.get_node(str(int(Location_X) - Add_X) + "-" + Location_Y).get_child_count() != 0:
			break
		Add_X += 1
	var Add_Y = 1
	# Now we are getting the vertical rows.
	while not Is_Null(Location_X + "-" + str(int(Location_Y) + Add_Y)):
		Areas.append(Location_X + "-" + str(int(Location_Y) + Add_Y))
		if Flow.get_node(Location_X +"-"+ str(int(Location_Y) + Add_Y)).get_child_count() != 0:
			break
		Add_Y += 1
	Add_Y = 1
	while not Is_Null(Location_X + "-" + str(int(Location_Y) - Add_Y)):
		Areas.append(Location_X + "-" + str(int(Location_Y) - Add_Y))
		if Flow.get_node(Location_X +"-"+ str(int(Location_Y) - Add_Y)).get_child_count() != 0:
			break
		Add_Y += 1
	
func Get_Diagonals(Flow):
	var Add_X = 1
	var Add_Y = 1
	while not Is_Null(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) + Add_Y)):
		Areas.append(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) + Add_Y))
		if Flow.get_node(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) + Add_Y)).get_child_count() != 0:
			break
		Add_X += 1
		Add_Y += 1
	Add_X = 1
	Add_Y = 1
	while not Is_Null(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) + Add_Y)):
		Areas.append(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) + Add_Y))
		if Flow.get_node(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) + Add_Y)).get_child_count() != 0:
			break
		Add_X += 1
		Add_Y += 1
	Add_X = 1
	Add_Y = 1
	while not Is_Null(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) - Add_Y)):
		Areas.append(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) - Add_Y))
		if Flow.get_node(str(int(Location_X) + Add_X) + "-" + str(int(Location_Y) - Add_Y)).get_child_count() != 0:
			break
		Add_X += 1
		Add_Y += 1
	Add_X = 1
	Add_Y = 1
	while not Is_Null(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) - Add_Y)):
		Areas.append(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) - Add_Y))
		if Flow.get_node(str(int(Location_X) - Add_X) + "-" + str(int(Location_Y) - Add_Y)).get_child_count() != 0:
			break
		Add_X += 1
		Add_Y += 1

func Get_Horse():
	var The_X = 2
	var The_Y = 1
	var number = 0
	while number != 8:
		# So this one is interesting. This is most likely the cleanest code here.
		# Get the numbers, replace the numbers, and loop until it stops.
		if not Is_Null(str(int(Location_X) + The_X) + "-" + str(int(Location_Y) + The_Y)):
			Areas.append(str(int(Location_X) + The_X) + "-" + str(int(Location_Y) + The_Y))
		number += 1
		match number:
			1:
				The_X = 1
				The_Y = 2
			2:
				The_X = -2
				The_Y = 1
			3:
				The_X = -1
				The_Y = 2
			4:
				The_X = 2
				The_Y = -1
			5:
				The_X = 1
				The_Y = -2
			6:
				The_X = -2
				The_Y = -1
			7:
				The_X = -1
				The_Y = -2

func Castle():
	# This is the castling section right here, used if a person wants to castle.
	var Flow = get_node("Flow")
	var X_Counter = 1
	# These are very similar to gathering a row, except we want free tiles and a rook
	# Counting up
	while not Is_Null(str(int(Location_X) + X_Counter) + "-" + Location_Y)&&Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child_count() == 0:
		X_Counter += 1
	if not Is_Null(str(int(Location_X) + X_Counter) + "-" + Location_Y)&&Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child(0).name == "Rook":
		if Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child(0).Castling == true:
			Areas.append(str(int(Location_X) + X_Counter) + "-" + Location_Y)
			Special_Area.append(str(int(Location_X) + 1) + "-" + Location_Y)
			Special_Area.append(str(int(Location_X) + 2) + "-" + Location_Y)
	# Counting down
	X_Counter = -1
	while not Is_Null(str(int(Location_X) + X_Counter) + "-" + Location_Y)&&Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child_count() == 0:
		X_Counter -= 1
	if not Is_Null(str(int(Location_X) + X_Counter) + "-" + Location_Y)&&Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child(0).name == "Rook":
		if Flow.get_node(str(int(Location_X) + X_Counter) + "-" + Location_Y).get_child(0).Castling == true:
			Areas.append(str(int(Location_X) + X_Counter) + "-" + Location_Y)
			Special_Area.append(str(int(Location_X) - 1) + "-" + Location_Y)
			Special_Area.append(str(int(Location_X) - 2) + "-" + Location_Y)

# One function that shortens everything. Its also a pretty good way to see if we went off the board or not.
func Is_Null(Location):
	if get_node_or_null("Flow/"+ Location) == null:
		return true
	else:
		return false

func save_board_state():
	#var board_data = {}
	var flow_node = get_node("Flow")

	#if board_data == null:
		#board_data = {}
	board_data["turn"] = Turn
	
	for child in flow_node.get_children():
		if child.get_child_count() > 0:
			var piece = child.get_child(0)
			var piece_info = {
				"type": piece.name,
				"color": piece.Item_Color,
				"double_start": piece.Double_Start if "Double_Start" in piece else null,
				"en_passant": piece.En_Passant if "En_Passant" in piece else null,
				"castling": piece.Castling if "Castling" in piece else null
			}
			board_data[child.name] = piece_info

	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if file == null:
		print("Erro ao abrir o arquivo para escrita.")
		return false

	#var jstr = JSON.stringify(board_data)
	
	var result = false
	if file:
		file.store_var(board_data)
		print("Dados salvos com sucesso no arquivo.")
		result = true
		#file.close()
		#print("Arquivo fechado com sucesso.")
	else:
		print("Falha ao abrir o arquivo para escrita.")

	return result

func load_board_state():
	if FileAccess.file_exists(save_path):
		print("load_board_state: Save file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		board_data = file.get_var()
		#file.close()
		Turn = board_data.get("turn", 0)
		
		print(board_data)

		var flow_node = get_node("Flow")
		for child in flow_node.get_children():
			if child.name in board_data:
				var piece_info = board_data[child.name]
				var piece = null
				match piece_info["type"]:
					"Pawn":
						piece = Pawn.new()
					"Bishop":
						piece = Bishop.new()
					"King":
						piece = King.new()
					"Queen":
						piece = Queen.new()
					"Rook":
						piece = Rook.new()
					"Knight":
						piece = Knight.new()
				if piece != null:
					piece.Item_Color = piece_info["color"]
					if piece_info["double_start"] != null:
						piece.Double_Start = piece_info["double_start"]
					if piece_info["en_passant"] != null:
						piece.En_Passant = piece_info["en_passant"]
					if piece_info["castling"] != null:
						piece.Castling = piece_info["castling"]

					child.add_child(piece) # Add the piece to the scene tree first
					#piece.position.clear()
					piece.position = pos # Set the position after adding to the tree
					
					#piece.position = pos
					#piece.reparent(child)
					#child.add_child(piece)
					#child.position = pos
	else:
		#if board_data.size() != 0:
		#board_data = {}
		print("No save file found")

	#print("Board: ", board_data);
