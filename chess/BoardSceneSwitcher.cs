using Godot;

public partial class BoardSceneSwitcher : Node
{
	public void SwitchScene(string scenePath)
	{
		GetTree().ChangeSceneToFile(scenePath);
	}
}
