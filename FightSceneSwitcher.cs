using Godot;

public partial class FightSceneSwitcher : Node
{
	public void SwitchScene(string scenePath)
	{
		GetTree().ChangeSceneToFile(scenePath);
	}
}
