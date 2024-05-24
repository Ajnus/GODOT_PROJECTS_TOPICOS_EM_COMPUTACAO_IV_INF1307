using Godot;
using System;

public partial class Global : Node
{
	public bool isInitializedMel = false;
	public bool isInitializedHideo = false;
	public bool isInitializedBoard = false;
	public bool isActuallyInitializedBoard = false;
	public Node testStageScene;
	public Node boardScene;

	public void PrintTreeRecursive(Node node, string indent = "")
	{
		GD.Print(indent + node.Name);
		foreach (Node child in node.GetChildren())
		{
			PrintTreeRecursive(child, indent + "  ");
		}
	}

	public override void _Ready()
	{
		//PrintTreeRecursive(GetTree().Root);
		testStageScene = GetTree().Root.GetChild(1).GetChild(0);
		boardScene = GetTree().Root.GetChild(1).GetChild(1);

		if (testStageScene == null)
		{
			GD.PrintErr("TestStage scene not found");
			return;
		}

		if (boardScene == null)
		{
			GD.PrintErr("BoardScene scene not found");
			return;
		}

		//PrintTreeRecursive(boardScene);
	}

	public void ExecuteOnceMel()
	{
		// Verifique se testStageScene foi inicializado corretamente
		if (testStageScene == null)
		{
			GD.PrintErr("ExecuteOnceMel: TestStage scene not initialized");
			return;
		}

		// GD.Print("Nome da cena: " + testStageScene.Name);
		var targetNode = testStageScene.GetNode<Node2D>("MEL");

		if (targetNode != null)
		{
			//GD.Print("Nó encontrado: " + targetNode.Name);
			targetNode.GlobalPosition = new Vector2(-175, 190);
		}
		else
		{
			GD.PrintErr("Node MEL not found");
		}

		isInitializedMel = true;
	}

	public void ExecuteOnceHideo()
	{
		// Verifique se testStageScene foi inicializado corretamente
		if (testStageScene == null)
		{
			GD.PrintErr("ExecuteOnceHideo: TestStage scene not initialized");
			return;
		}

		//GD.Print("Nome da cena: " + testStageScene.Name);
		var targetNode = testStageScene.GetNode<Node2D>("HIDEO");

		if (targetNode != null)
		{
			//GD.Print("Nó encontrado: " + targetNode.Name);
			targetNode.GlobalPosition = new Vector2(236, 190);
		}
		else
		{
			GD.PrintErr("Node HIDEO not found");
		}

		isInitializedHideo = true;
	}

	public void ExecuteOnceBoard()
	{
		if (boardScene == null)
		{
			GD.PrintErr("ExecuteOnceBoard: BoardScene scene not initialized");
			return;
		}

		GD.Print("Nome da cena: " + boardScene.Name);
		var targetNode = boardScene.GetNode<Node2D>("HIDEO");

		if (targetNode != null)
		{
			//GD.Print("Nó encontrado: " + targetNode.Name);
			targetNode.GlobalPosition = new Vector2(236, 190);
		}
		else
		{
			GD.PrintErr("Node BOARD not found");
		}

		isInitializedBoard = true;
	}


	}

