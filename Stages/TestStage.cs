using Godot;
using System;

public partial class TestStage : Node2D
{
	public FightSceneSwitcher sceneSwitcher;
	public Mel mel;
	public Hideo hideo;

	public override void _Ready()
	{
		// Tente obter o nó FightSceneSwitcher
		sceneSwitcher = GetNode<FightSceneSwitcher>("FightSceneSwitcher");
		mel = GetNode<Mel>("MEL");
		hideo = GetNode<Hideo>("HIDEO");

		//mel.GlobalPosition = new Vector2(-262, 209);
		//hideo.GlobalPosition = new Vector2(236, 215);
		
		// Verifique se o nó foi encontrado
		if (sceneSwitcher == null)
		{
			//GD.Print("TESTSTAGE: FightSceneSwitcher node not found");
		}
		else
		{
			//GD.Print("TESTSTAGE: FightSceneSwitcher node found: " + sceneSwitcher.Name);
		}
	}

	public void SwitchToNextScene(string scene_path)
	{
		mel.Save();
		hideo.Save();

		//GD.Print("TESTSTAGE: scene_path: " + scene_path);
		
		if (sceneSwitcher != null)
		{
			//GD.Print("TESTSTAGE: sceneSwitcher: " + sceneSwitcher.Name);
			sceneSwitcher.SwitchScene(scene_path);
		}
		else
		{
			//GD.Print("TESTSTAGE: Cannot switch scene: FightSceneSwitcher is null");
		}
	
	}

	public override void _PhysicsProcess(double delta)
	{
		if (Input.IsActionJustPressed("change_scene"))
			{
				//GD.Print("TESTSTAGE: Change scene action pressed");
				SwitchToNextScene("res://Chess/Board.tscn");
			}
	}
}
