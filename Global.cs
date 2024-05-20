using Godot;
using System;

public partial class Global : Node
{
	public bool isInitializedMel = false;
	public bool isInitializedHideo = false;
	public Node testStageScene;

	
	public override void _Ready()
	{
		testStageScene = testStageScene = GetTree().Root.GetChild(1);
		
		/*
		if (!isInitialized)
		{
			GD.Print("Executando função uma vez durante a execução do programa.");
			ExecuteOnce();
			isInitialized = true;
		}
		*/
	}
	
	public void ExecuteOnceMel()
	{
		GD.Print("Nome da cena: " + testStageScene.Name);
		var targetNode = testStageScene.GetNode<Node2D>("MEL");

		if (targetNode != null)
		{
			GD.Print("Nó encontrado: " + targetNode.Name);
			targetNode.GlobalPosition = new Vector2(-175, 190);
		}
		isInitializedMel = true;
	}

	public void ExecuteOnceHideo()
	{
		GD.Print("Nome da cena: " + testStageScene.Name);
		var targetNode = testStageScene.GetNode<Node2D>("HIDEO");

		if (targetNode != null)
		{
			GD.Print("Nó encontrado: " + targetNode.Name);
			targetNode.GlobalPosition = new Vector2(236, 190);
		}
		isInitializedHideo = true;
	}
}
