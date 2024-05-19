using Godot;
using System;

public partial class TestStage : Node2D
{
	public SceneSwitcher sceneSwitcher;

	public override void _Ready()
	{
		sceneSwitcher = GetNode<SceneSwitcher>("SceneSwitcher");
	}

	public void SwitchToNextScene(string scene_path)
	{
		sceneSwitcher.SwitchScene(scene_path);
	}

	public void _Process(float delta)
	{
		// Called every frame. 'delta' is the elapsed time since the previous frame.
	}
}
