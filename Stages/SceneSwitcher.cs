using Godot;

public partial class SceneSwitcher : Node
{
	public void SwitchScene(string scenePath)
	{
		GetTree().ChangeSceneToFile(scenePath);
	}
}
